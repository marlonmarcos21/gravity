import axios from 'axios';
import React, { useEffect, useState, useRef } from 'react';
import PropTypes from 'prop-types';
import {
  Avatar,
  AvatarGroup,
  Message,
  MessageInput,
  ConversationList,
  Conversation,
} from '@chatscope/chat-ui-kit-react';
import Chat from './Chat';
import consumer from '../packs/channels/consumer'
import '../styles/chat.scss';

const getCurrentDimension = () => {
  return window.innerWidth;
}

const ChatList = (props) => {
  const { autoScroll, currentUser } = props;
  const [conversations, setConversations] = useState([]);
  const [loadingMore, setLoadingMore] = useState(false);
  const [stopFetching, setStopFetching] = useState(false);
  const [chatWindowHtml, setChatWindowHtml] = useState(null);
  const [lastMessageMapping, setLastMessageMapping] = useState({});
  const [windowWidth, setWindowWidth] = useState(getCurrentDimension());
  const pageRef = useRef(1);

  const subscribe = (chatGroupId) => {
    consumer.subscriptions.create({channel: 'GravityChannel', room_id: chatGroupId, chat_list: true}, {
      received(data) {
        if ('is_read' in data) return;
        if ('is_typing' in data) return;

        const newMsgMap = {}
        newMsgMap[chatGroupId] = data.body
        setLastMessageMapping({...lastMessageMapping, ...newMsgMap});
      },
    });
  };

  const getConversations = (page = 1) => {
    try {
      axios.get(
        `/chats/conversations?page=${page}`, {
          headers: {'Content-Type': 'application/json'},
        }
      ).then(r => {
        if (r.data.length > 0) {
          r.data.forEach(chatGroup => {
            subscribe(chatGroup.id)
          });
          setConversations(conversations.concat(r.data));
        } else {
          setStopFetching(true);
        }
      });
    } catch (err) {
      console.error(err);
    }
  };

  useEffect(() => {
    getConversations();

    const queryString = window.location.search;
    const urlParams = new URLSearchParams(queryString);
    const chatGroupId = urlParams.get('chat_group_id');
    if (chatGroupId) showChatWindowHtml({id: chatGroupId, avatarSources: []});
  }, []);

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

  const onYReachEnd = () => {
    if (autoScroll && !stopFetching) setLoadingMore(true);
  };

  const showChatWindowHtml = (chatGroup) => {
    const key = 'chat-group-' + chatGroup.id
    if (chatWindowHtml && chatWindowHtml.props.children.key === key) {
      return;
    }

    const chatWindowHtml_ = (
      <React.Fragment>
        <Chat
          key={key}
          currentUser={currentUser}
          chatGroup={chatGroup}
        />
      </React.Fragment>
    )
    setChatWindowHtml(chatWindowHtml_)
  }

  return (
    <div id="main-chat-container" style={{display: 'flex', height: '500px', width: autoScroll ? '100%' : '350px'}}>
      {(!chatWindowHtml || (chatWindowHtml && windowWidth > 768)) &&
        <ConversationList
          style={{height: '500px'}}
          scrollable
          loadingMore={!stopFetching && loadingMore}
          onYReachEnd={onYReachEnd}
        >
          {conversations.map(d => {
            return (
              <Conversation
                key={'conversation-list-' + d.id}
                name={d.roomName}
                info={lastMessageMapping[d.id] || d.message}
                onClick={() => autoScroll ? showChatWindowHtml(d) : window.location.replace(`/chats?chat_group_id=${d.id}`)}
              >
                {d.avatarSources.length > 1
                  ? (
                      <AvatarGroup
                        size="sm"
                        hoverToFront={true}
                      >
                        {d.avatarSources.map((s, i) => { return (<Avatar key={`a-${d.id}-${i}`} src={s} name={d.roomName} />); })}
                      </AvatarGroup>
                    )
                  : <Avatar src={d.avatarSources[0]} name={d.roomName} />
                }
              </Conversation>
            )
          })}
        </ConversationList>
      }
      {chatWindowHtml}
    </div>
  );
}

export default ChatList;
