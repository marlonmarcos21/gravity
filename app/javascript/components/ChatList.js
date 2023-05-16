import axios from 'axios';
import React, { useEffect, useState } from "react"
import PropTypes from "prop-types"
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
import "../styles/chat.scss";

const ChatList = () => {
  const [conversations, setConversations] = useState([]);
  const [loadingMore, setLoadingMore] = useState(false);

  const getConversations = (page = 1) => {
    try {
      axios.get(`/chats/conversations?page=${page}`).then(r => {
        setConversations(conversations.concat(r.data));
      });
    } catch (err) {
      console.error(err);
    }
  };

  if (conversations.length === 0) {
    getConversations()
  }

  useEffect(() => {
    if (loadingMore === true) {
      setTimeout(() => {
        let currentPage = 1;
        if (conversations.length !== 0) {
          const lastConvo = conversations.slice(-1);
          currentPage = lastConvo[0].id
        }

        getConversations(currentPage + 1);
        setLoadingMore(false);
      }, 1000);
    }
  }, [loadingMore]);

  const onYReachEnd = () => setLoadingMore(true);

  return (
    <ConversationList style={{height: "340px"}} scrollable loadingMore={loadingMore} onYReachEnd={onYReachEnd}>
      {conversations.map(d => {
        return (
          <Conversation key={'conversation-id-' + d.id} name={d.firstName} lastSenderName={d.lastName} info={d.message}>
            <Avatar src={d.avatarSrc} name={d.firstName} />
          </Conversation>
        )
      })}
    </ConversationList>
  );
}

export default ChatList;
