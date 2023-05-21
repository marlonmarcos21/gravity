import axios from 'axios';
import React, { useEffect, useState, useRef } from 'react';
import PropTypes from 'prop-types';
import {
  Avatar,
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
import '../styles/Chat.scss';

let groups = [];

const Chat = (props) => {
  const { currentUser, chatGroup } = props;
  const [msgGroups, setMsgGroups] = useState([]);
  const [isTyping, setIsTyping] = useState(false);
  const [loadingMore, setLoadingMore] = useState(false);
  const [stopFetching, setStopFetching] = useState(false);
  const groupIdRef = useRef(0);
  const msgIdRef = useRef(0);
  const inputRef = useRef();
  const pageRef = useRef(1);

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
        const newMsg = {_id: `m-${++msgIdRef.current}`, message: msg.body, sender: String(msg.sender_id)}
        let newMessages;

        if (append) {
          newMessages = [...lastGroup.messages].concat(newMsg);
        } else {
          newMessages = [newMsg].concat([...lastGroup.messages]);
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
          messages: [{
            _id: `m-${++msgIdRef.current}`,
            message: msg.body,
            sender: String(msg.sender_id),
          }]
        };

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
        messages: [{
          _id: `m-${++msgIdRef.current}`,
          message: msg.body,
          sender: String(msg.sender_id),
        }]
      };
      groups = [newGroup];
    }
  };

  const getMessages = (page = 1) => {
    try {
      axios.get(`/chats/${chatGroup.id}?page=${page}`).then(r => {
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
      axios.get(`/chats/conversations/${chatGroup.id}`).then(r => {
        if (r.data) {
          chatGroup.firstName = r.data.firstName;
          chatGroup.message = r.data.message;
          chatGroup.avatarSrc = r.data.avatarSrc;
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
    getExistingSubscription().send({sent_by: currentUser.id, body});
  };

  const notifyIsTyping = (value) => {
    getExistingSubscription().send({user_id: currentUser.id, is_typing: value});
  };

  useEffect(() => {
    getMessages();
    if (!chatGroup.avatarSrc) getConversation();
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
            handleMessage({sender_id: data.sent_by, body: data.body}, true);
            setMsgGroups(groups);
            setIsTyping(false);
            this.send({is_read: true});
          }
        },
      });

      setTimeout(() => {
        subscription.send({is_read: true});
      }, 1000);
    }
  }, [chatGroup.id]);

  useEffect(() => {
    if (loadingMore === true) {
      if (groups.length !== 0) {
        ++pageRef.current;
      }

      setLoadingMore(false);
      if (!stopFetching) {
        getMessages(pageRef.current);
      }
    }
  }, [loadingMore]);

  const onYReachStart = () => setLoadingMore(true);

  return (
    <div className="chat-group-container" style={{flexGrow: 1}}>
      <span id="mobile-back-to-list"><a href="/chats">&#x2190; Back to List</a></span>
      <ChatContainer>
        <ConversationHeader>
          <Avatar src={chatGroup.avatarSrc} name={chatGroup.firstName} />
          <ConversationHeader.Content userName={chatGroup.firstName} info="" />
        </ConversationHeader>

        <MessageList
          loadingMorePosition="top"
          disableOnYReachWhenNoScroll={true}
          typingIndicator={isTyping && <TypingIndicator/>}
          onYReachStart={onYReachStart}
        >
          {groups.map(g => (
            <MessageGroup style={{padding: '8px'}} key={g._id} data-id={g._id} direction={g.direction}>
              <MessageGroup.Messages key={g._id}>
                {g.messages.map((m, i) => (
                  <Message key={m._id} data-id={m._id} model={m} style={{padding: '2px'}} avatarSpacer={g.messages[i + 1] && g.senderId != currentUser.id}>
                    {!g.messages[i + 1] && g.senderId != currentUser.id &&
                      <Avatar src={chatGroup.avatarSrc} />
                    }
                  </Message>
                ))}
              </MessageGroup.Messages>
            </MessageGroup>
          ))}
        </MessageList>

        <MessageInput
          placeholder="Type message here"
          ref={inputRef}
          onSend={m => handleSendMessage(m)}
          onChange={m => { notifyIsTyping(m.length > 0) }}
        />
      </ChatContainer>
    </div>
  );
}

export default Chat;
