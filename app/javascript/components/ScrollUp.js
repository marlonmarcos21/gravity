import React, { useEffect, useState } from 'react';

const ScrollUp = () => {
  const scrollToTop = () => {
    window.scrollTo({
      top: 0,
      behavior: 'smooth'
    });
  };

  return (
    <div id="scroll-up">
      <a className="page-scroll" onClick={scrollToTop} style={{cursor: 'pointer'}}>
        <i className="fa fa-chevron-up fa-2x"></i>
      </a>
    </div>
  );
}

export default ScrollUp;
