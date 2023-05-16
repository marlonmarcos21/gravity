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
} from "@chatscope/chat-ui-kit-react";
import Chat from './Chat';
import "../styles/chat.scss";

const ChatList = () => {
  const [conversations, setConversations] = useState([]);
  const [loadingMore, setLoadingMore] = useState(false);
  const [stopFetching, setStopFetching] = useState(false);
  const [chatWindowHtml, setChatWindowHtml] = useState(null);

  const getConversations = (page = 1) => {
    try {
      axios.get(`/chats/conversations?page=${page}`).then(r => {
        if (r.data.length > 0) {
          setConversations(conversations.concat(r.data));
        } else {
          setStopFetching(true);
        }
      });
    } catch (err) {
      console.error(err);
    }
  };

  if (conversations.length === 0) {
    getConversations()
  }

  const pageRef = useRef(1);

  useEffect(() => {
    if (loadingMore === true) {
      setTimeout(() => {
        if (conversations.length !== 0) {
          ++pageRef.current;
        }

        setLoadingMore(false);
        if (!stopFetching) {
          getConversations(pageRef.current);
        }
      }, 1000);
    }
  }, [loadingMore]);

  const onYReachEnd = () => setLoadingMore(true);

  const showChatWindowHtml = (chatGroupId) => {
    const chatWindowHtml_ = (
      <React.Fragment>
        <Chat key={'chat-group-' + chatGroupId} />
      </React.Fragment>
    )
    setChatWindowHtml(chatWindowHtml_)
  }

  return (
    <div>
      <ConversationList
        style={{height: "340px"}}
        scrollable
        loadingMore={loadingMore}
        onYReachEnd={onYReachEnd}
      >
        {conversations.map(d => {
          return (
            <Conversation
              key={'conversation-list-id-' + d.id}
              name={d.firstName}
              info={d.message}
              onClick={() => showChatWindowHtml(d.id)}
            >
              <Avatar src={d.avatarSrc} name={d.firstName} />
            </Conversation>
          )
        })}
      </ConversationList>
      {chatWindowHtml}
    </div>
  );
}

export default ChatList;
