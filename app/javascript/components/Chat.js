import axios from 'axios';
import React, { useEffect, useState, useRef } from 'react';
import PropTypes from 'prop-types';
import {
  Avatar,
  MainContainer,
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

  const handleSendMessage = (body) => {
    const subscriptions = consumer.subscriptions.subscriptions;
    const existingSubscription = subscriptions.filter(s => {
      return JSON.parse(s.identifier).room_id === chatGroup.id;
    });

    existingSubscription[0].send({sent_by: currentUser.id, body});
    handleMessage({sender_id: currentUser.id, body }, true);
    setMsgGroups(groups);
  };

  const notifyIsTyping = (value) => {
    const subscriptions = consumer.subscriptions.subscriptions;
    const existingSubscription = subscriptions.filter(s => {
      return JSON.parse(s.identifier).room_id === chatGroup.id;
    });

    if (existingSubscription.length >= 1) {
      existingSubscription[0].send({user_id: currentUser.id, is_typing: value});
    }
  };

  useEffect(() => getMessages(), []);

  useEffect(() => {
    groups = [];
    const subscriptions = consumer.subscriptions.subscriptions;
    subscriptions.forEach(s => s.unsubscribe());
    consumer.subscriptions.create({channel: 'GravityChannel', room_id: chatGroup.id}, {
      received(data) {
        if ('is_typing' in data) {
          if (data.user_id !== currentUser.id) {
            setIsTyping(data.is_typing);
          }
        } else {
          if (data.sent_by === currentUser.id) {
            return;
          }

          handleMessage({sender_id: data.sent_by, body: data.body}, true);
          setMsgGroups(groups);
          setIsTyping(false);
        }
      },
    });
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
    <div style={{flexGrow: 1}}>
      <ChatContainer>
        <ConversationHeader>
          <Avatar src={chatGroup.avatarSrc} name={chatGroup.firstName} />
          <ConversationHeader.Content userName={chatGroup.firstName} info="Active 10 mins ago" />
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
