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
  VoiceCallButton,
  VideoCallButton,
  InfoButton,
  TypingIndicator,
  MessageSeparator,
} from "@chatscope/chat-ui-kit-react";
import "../styles/chat.scss";

const Chat = () => {
  return (
    <div style={{height: "500px"}}>
      <ChatContainer>
        <ConversationHeader>
          <Avatar src="https://static-dev.gravity.ph/users/profile_photos/000/000/001/thumb/mm.jpg?1642640892" name="Emily" />
          <ConversationHeader.Content userName="Emily" info="Active 10 mins ago" />
          <ConversationHeader.Actions>
            <VoiceCallButton />
            <VideoCallButton />
            <InfoButton />
          </ConversationHeader.Actions>          
        </ConversationHeader>
        <MessageList typingIndicator={<TypingIndicator content="Emily is typing" />}>

          <MessageSeparator content="Saturday, 30 November 2019" />
            
          <Message model={{
            message: "Hello my friend",
            sentTime: "15 mins ago",
            sender: "Emily",
            direction: "incoming",
            position: "single"
          }}>
            <Avatar src="https://static-dev.gravity.ph/users/profile_photos/000/000/001/thumb/mm.jpg?1642640892" name={"Emily"} />
          </Message>

          <Message model={{
            message: "Hello my friend",
            sentTime: "15 mins ago",
            sender: "Marlon",
            direction: "outgoing",
            position: "single"
          }} />

          <Message model={{
            message: "Hello my friend",
            sentTime: "15 mins ago",
            sender: "Emily",
            direction: "incoming",
            position: "first"
          }} avatarSpacer />

          <Message model={{
            message: "Hello my friend",
            sentTime: "15 mins ago",
            sender: "Emily",
            direction: "incoming",
            position: "normal"
          }} avatarSpacer />

          <Message model={{
            message: "Hello my friend",
            sentTime: "15 mins ago",
            sender: "Emily",
            direction: "incoming",
            position: "normal"
          }} avatarSpacer />

          <Message model={{
            message: "Hello my friend",
            sentTime: "15 mins ago",
            sender: "Emily",
            direction: "incoming",
            position: "last"
          }}>
            <Avatar src="https://static-dev.gravity.ph/users/profile_photos/000/000/001/thumb/mm.jpg?1642640892" name={"Emily"} />
          </Message>

          <Message model={{
            message: "Hello my friend",
            sentTime: "15 mins ago",
            direction: "outgoing",
            position: "first"
          }} />

          <Message model={{
            message: "Hello my friend",
            sentTime: "15 mins ago",
            direction: "outgoing",
            position: "normal"
          }} />

          <Message model={{
            message: "Hello my friend",
            sentTime: "15 mins ago",
            direction: "outgoing",
            position: "normal"
          }} />

          <Message model={{
            message: "Hello my friend",
            sentTime: "15 mins ago",
            direction: "outgoing",
            position: "last"
          }} />

          <Message model={{
            message: "Hello my friend",
            sentTime: "15 mins ago",
            sender: "Emily",
            direction: "incoming",
            position: "first"
          }} avatarSpacer />

          <Message model={{
            message: "Hello my friend",
            sentTime: "15 mins ago",
            sender: "Emily",
            direction: "incoming",
            position: "last"
          }}>
            <Avatar src="https://static-dev.gravity.ph/users/profile_photos/000/000/001/thumb/mm.jpg?1642640892" name={"Emily"} />
          </Message>

          <MessageSeparator content="Saturday, 31 November 2019" />

          <Message model={{
            message: "Hello my friend",
            sentTime: "15 mins ago",
            sender: "Emily",
            direction: "incoming",
            position: "single"
          }}>
            <Avatar src="https://static-dev.gravity.ph/users/profile_photos/000/000/001/thumb/mm.jpg?1642640892" name={"Emily"} />
          </Message>

          <Message model={{
            message: "Hello my friend",
            sentTime: "15 mins ago",
            sender: "Marlon",
            direction: "outgoing",
            position: "single"
          }} />

          <Message model={{
            message: "Hello my friend",
            sentTime: "15 mins ago",
            sender: "Emily",
            direction: "incoming",
            position: "first"
          }} avatarSpacer />

          <Message model={{
            message: "Hello my friend",
            sentTime: "15 mins ago",
            sender: "Emily",
            direction: "incoming",
            position: "normal"
          }} avatarSpacer />

          <Message model={{
            message: "Hello my friend",
            sentTime: "15 mins ago",
            sender: "Emily",
            direction: "incoming",
            position: "normal"
          }} avatarSpacer />

          <Message model={{
            message: "Hello my friend",
            sentTime: "15 mins ago",
            sender: "Emily",
            direction: "incoming",
            position: "last"
          }}>
            <Avatar src="https://static-dev.gravity.ph/users/profile_photos/000/000/001/thumb/mm.jpg?1642640892" name={"Emily"} />
          </Message>

          <Message model={{
            message: "Hello my friend",
            sentTime: "15 mins ago",
            direction: "outgoing",
            position: "first"
          }} />

          <Message model={{
            message: "Hello my friend",
            sentTime: "15 mins ago",
            direction: "outgoing",
            position: "normal"
          }} />

          <Message model={{
            message: "Hello my friend",
            sentTime: "15 mins ago",
            direction: "outgoing",
            position: "normal"
          }} />

          <Message model={{
            message: "Hello my friend",
            sentTime: "15 mins ago",
            direction: "outgoing",
            position: "last"
          }} />
            
          <Message model={{
            message: "Hello my friend",
            sentTime: "15 mins ago",
            sender: "Emily",
            direction: "incoming",
            position: "first"
          }} avatarSpacer />

          <Message model={{
            message: "Hello my friend",
            sentTime: "15 mins ago",
            sender: "Emily",
            direction: "incoming",
            position: "last"
          }}>
            <Avatar src="https://static-dev.gravity.ph/users/profile_photos/000/000/001/thumb/mm.jpg?1642640892" name={"Emily"} />
          </Message>
            
          </MessageList>
        <MessageInput placeholder="Type message here" />        
      </ChatContainer>
    </div>
  );
}

export default Chat;
