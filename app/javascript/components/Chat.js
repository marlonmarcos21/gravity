import axios from 'axios';
import React, { useEffect, useState, useRef } from 'react';
import PropTypes from 'prop-types';
import {
  Avatar,
  AvatarGroup,
  ChatContainer,
  MessageList,
  Message,
  MessageInput,
  ConversationList,
  Conversation,
  ConversationHeader,
  TypingIndicator,
  MessageSeparator,
  MessageGroup,
} from '@chatscope/chat-ui-kit-react';
import consumer from '../packs/channels/consumer'
import '../styles/chat.scss';

let groups = [];

const Chat = (props) => {
  const { currentUser, chatGroup } = props;
  const [msgGroups, setMsgGroups] = useState([]);
  const [isTyping, setIsTyping] = useState(false);
  const [loadingMore, setLoadingMore] = useState(false);
  const [stopFetching, setStopFetching] = useState(false);
  const [inputValue, setInputValue] = useState('');
  const [fileUploaded, setFileUploaded] = useState(null);
  const [selectedFile, setSelectedFile] = useState(null);
  const [filePreview, setFilePreview] = useState('');
  const groupIdRef = useRef(0);
  const msgIdRef = useRef(0);
  const inputRef = useRef();
  const pageRef = useRef(1);
  const hiddenFileInput = useRef(null);

  const handleMessage = (msg, append) => {
    if (groups.length > 0) {
      let lastGroup;

      if (append) {
        lastGroup = groups[groups.length - 1];
      } else {
        lastGroup = groups[0];
      }

      if (lastGroup.senderId === msg.sender_id) {
        // Add to group
        const newMsgs = []

        if (msg.body !== '') {
          newMsgs.push({
            _id: `m-${++msgIdRef.current}`,
            message: msg.body,
            sender: String(msg.sender_id),
            avatarSrc: msg.avatar_source,
          });
        }

        if (msg.attachment) {
          newMsgs.push({
            _id: `m-${++msgIdRef.current}`,
            message: '',
            sender: String(msg.sender_id),
            attachment: msg.attachment,
            avatarSrc: msg.avatar_source,
          });
        }

        if (newMsgs.length === 0) return;

        let newMessages;

        if (append) {
          newMessages = [...lastGroup.messages].concat(newMsgs);
        } else {
          newMessages = newMsgs.concat([...lastGroup.messages]);
        }

        const newGroup = { ...lastGroup, messages: newMessages};

        if (append) {
          groups = groups.slice(0, -1).concat(newGroup);
        } else {
          groups.shift();
          const newGroups = [newGroup].concat(groups);
          groups = newGroups;
        }
      } else {
        // Sender different than last sender - create new group 
        const newGroup = {
          _id: `g-${++groupIdRef.current}`,
          direction: msg.sender_id === currentUser.id ? 'outgoing' : 'incoming',
          senderId: msg.sender_id,
          messages: [],
        };

        if (msg.body !== '') {
          newGroup.messages.push({
            _id: `m-${++msgIdRef.current}`,
            message: msg.body,
            sender: String(msg.sender_id),
            avatarSrc: msg.avatar_source,
          });
        }

        if (msg.attachment) {
          newGroup.messages.push({
            _id: `m-${++msgIdRef.current}`,
            message: msg.body,
            sender: String(msg.sender_id),
            attachment: msg.attachment,
            avatarSrc: msg.avatar_source,
          });
        }

        if (newGroup.messages.length === 0) return;

        if (append) {
          groups = groups.concat(newGroup);
        } else {
          groups = [newGroup].concat(groups);
        }
      }
    } else {
      const newGroup = {
        _id: `g-${++groupIdRef.current}`,
        direction:  msg.sender_id === currentUser.id ? 'outgoing' : 'incoming',
        senderId: msg.sender_id,
        messages: [],
      };

      if (msg.body !== '') {
        newGroup.messages.push({
          _id: `m-${++msgIdRef.current}`,
          message: msg.body,
          sender: String(msg.sender_id),
          avatarSrc: msg.avatar_source,
        });
      }

      if (msg.attachment) {
        newGroup.messages.push({
          _id: `m-${++msgIdRef.current}`,
          message: '',
          sender: String(msg.sender_id),
          attachment: msg.attachment,
          avatarSrc: msg.avatar_source,
        });
      }

      if (newGroup.messages.length === 0) return;

      groups = [newGroup];
    }
  };

  const getMessages = (page = 1) => {
    try {
      axios.get(
        `/chats/${chatGroup.id}?page=${page}`, {
          headers: {'Content-Type': 'application/json'},
        }
      ).then(r => {
        if (r.data.length > 0) {
          r.data.forEach(msg => {
            handleMessage(msg);
          });
          setMsgGroups(groups);
        } else {
          setStopFetching(true);
        }
      });
    } catch (err) {
      console.error(err);
    }
  };

  const getConversation = () => {
    try {
      axios.get(
        `/chats/conversations/${chatGroup.id}`, {
          headers: {'Content-Type': 'application/json'},
        }
      ).then(r => {
        if (r.data) {
          chatGroup.roomName = r.data.roomName;
          chatGroup.message = r.data.message;
          chatGroup.avatarSources = r.data.avatarSources;
        }
      });
    } catch (err) {
      console.error(err);
    }
  };

  const getExistingSubscription = () => {
    const subscriptions = consumer.subscriptions.subscriptions;
    return subscriptions.find(s => {
      const identifier = JSON.parse(s.identifier);
      return !identifier.chat_list && identifier.room_id === chatGroup.id;
    });
  };

  const handleSendMessage = (body) => {
    setInputValue('');

    if (filePreview !== '') {
      body = body.replace(filePreview, '').trim();
    }

    const payload = {sender_id: currentUser.id, body};

    if (selectedFile) {
      payload.attachment = selectedFile;
      payload.file_name = fileUploaded.name;
      URL.revokeObjectURL(fileUploaded);
      setFileUploaded(null);
    }

    getExistingSubscription().send(payload);
  };

  const notifyIsTyping = (value) => {
    setInputValue(value);
    getExistingSubscription().send({user_id: currentUser.id, is_typing: value.length > 0});
  };

  useEffect(() => {
    getMessages();
    if (!chatGroup.roomName) getConversation();
  }, []);

  useEffect(() => {
    groups = [];

    let subscription = getExistingSubscription();

    if (!subscription) {
      subscription = consumer.subscriptions.create({channel: 'GravityChannel', room_id: chatGroup.id}, {
        received(data) {
          if ('is_read' in data) return;

          if ('is_typing' in data) {
            if (data.user_id !== currentUser.id) {
              setIsTyping(data.is_typing);
            }
          } else {
            handleMessage({ ...data }, true);
            setMsgGroups(groups);
            setIsTyping(false);
            if (currentUser.id !== data.sender_id) {
              this.send({is_read: true});
            }
          }
        },
      });

      setTimeout(() => {
        subscription.send({is_read: true});
      }, 1000);
    }

    inputRef.current.focus();
  }, [chatGroup.id]);

  useEffect(() => {
    if (loadingMore === true) {
      setTimeout(() => {
        if (groups.length !== 0) {
          ++pageRef.current;
        }

        setLoadingMore(false);
        if (!stopFetching) {
          getMessages(pageRef.current);
        }
      }, 500);
    }
  }, [loadingMore]);

  const onYReachStart = () => setLoadingMore(true);

  const handleAttachClick = () => {
    hiddenFileInput.current.click();
  };

  const handleFileChange = event => {
    const file = event.target.files[0];
    setFileUploaded(file);

    const blob = URL.createObjectURL(file);
    const reader = new FileReader();
    reader.onloadend = () => {
      setSelectedFile(reader.result);
    };
    reader.readAsDataURL(file);
    const preview = inputValue === '' ? `<img width="200" src="${blob}" />` : `<br><img width="200" src="${blob}" />`;
    setFilePreview(preview);
    setInputValue((inputValue + preview).trim());
  };

  return (
    <div className="chat-group-container" style={{flexGrow: 1}}>
      <span id="mobile-back-to-list"><a href="/chats">&#x2190; Back to List</a></span>
      <ChatContainer>
        <ConversationHeader>
          {chatGroup.avatarSources.length > 1
            ? (
                <AvatarGroup
                  size="md"
                  hoverToFront={true}
                  style={{width: "68px", height: "68px"}}
                >
                  {chatGroup.avatarSources.map((s, i) => { return (<Avatar key={`a-${chatGroup.id}-${i}`} src={s} name={chatGroup.roomName} />); })}
                </AvatarGroup>
              )
            : <Avatar src={chatGroup.avatarSources[0]} name={chatGroup.roomName} />
          }
          <ConversationHeader.Content userName={chatGroup.roomName} info="" style={{marginLeft: chatGroup.avatarSources.length > 1 ? '15px': ''}}/>
        </ConversationHeader>

        <MessageList
          loadingMorePosition="top"
          disableOnYReachWhenNoScroll={true}
          typingIndicator={isTyping && <TypingIndicator/>}
          onYReachStart={onYReachStart}
          autoScrollToBottom={true}
          autoScrollToBottomOnMount={true}
        >
          {groups.map(g => (
            <MessageGroup style={{padding: '8px'}} key={g._id} data-id={g._id} direction={g.direction}>
              <MessageGroup.Messages key={g._id}>
                {g.messages.map((m, i) => (
                  <Message key={m._id} data-id={m._id} model={m} style={{padding: '2px'}} avatarSpacer={g.messages[i + 1] && g.senderId != currentUser.id}>
                    {!g.messages[i + 1] && g.senderId != currentUser.id &&
                      <Avatar src={m.avatarSrc} size="sm"/>
                    }
                    {m.attachment && <Message.ImageContent src={m.attachment} width={200} />}
                  </Message>
                ))}
              </MessageGroup.Messages>
            </MessageGroup>
          ))}
        </MessageList>

        <MessageInput
          placeholder="Type message here"
          value={inputValue}
          ref={inputRef}
          onSend={m => handleSendMessage(m)}
          onAttachClick={handleAttachClick}
          onChange={m => { notifyIsTyping(m) }}
          sendDisabled={!inputValue}
        />
      </ChatContainer>

      <input
        type="file"
        name="file"
        ref={hiddenFileInput}
        onChange={handleFileChange}
        style={{display:'none'}}
      />
    </div>
  );
}

export default Chat;
