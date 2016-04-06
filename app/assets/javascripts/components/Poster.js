import React from 'react';

export default React.createClass({

  showTrama() {
    let encodedQuery = encodeURI(this.props.movie.title);
    let url = "http://www.comingsoon.it/cerca/?q=" + encodedQuery
    let win = window.open(url, '_blank');
    win.focus();
  },

  render() {

    return <div className="poster" onClick={this.showTrama}>
            <img className="" src={this.props.movie.poster_url} />
            <div className="meta-data">{this.props.movie.title + ' ' + this.props.movie.year}</div>
           </div>
    
  }
});
