import React from 'react';
import axios from 'axios';
import _ from 'lodash';
//import ReactCSSTransitionGroup from 'react-addons-css-transition-group';
import Poster from '../components/Poster'

export default React.createClass({
  getInitialState() {

    // when entering the first time clean the url
    history.replaceState({}, 'movies', '/');
    // window.addEventListener("popstate", function(e) {
    //   // URL location
    //   var location = document.location;
    //   // state
    //   var state = e.state;
    //   // return to last state
    //   if (state.view == "EMAILCONTENT") {
    //     ...
    //   }
    // });

    return {
      movies: [],
      notFound: false
    }
  },

  componentDidMount() {
    // fetch APIs
    axios.get('/index')
      .then( (response) => {
        if (response.status) {
          this.setState({movies: response.data, notFound: false})
        }
      })
      .catch( (err) => {
        console.log(err, err.stack);
      });
  },

  search() {
    let query = document.getElementById('search-bar').value
    history.pushState({search: query}, query, `?${query}`);
    console.log(history)
    axios.get('/index', {
      params: {
        search: query
      }
    }).then( (response) => {
        this.setState({movies: response.data, notFound: false});
        console.log(response);
      })
      .catch( (response) => {
        this.setState({notFound: true});
      });
  },

  returnToHome() {
    history.replaceState({}, 'movies', '/');
    location.reload();
  },

  render() {

    if(this.state.notFound) {
      return <div className="row">
              <div className="four columns offset-by-four not-found-msg">
                <a onClick={this.returnToHome}>Torna alla home</a>
              </div>
            </div>
      
    }

    if(this.state.movies.length > 0) {
      let posters = _.map(this.state.movies, (movie, index)=>{
        return <Poster movie={movie} key={index} />
      })
      return  <div>
                <div className="row">
                  <div className="twelve columns">
                    <input className="u-full-width" type="text" placeholder="search..." id="search-bar" />
                    <div className="u-full-width" id="search-bar-clone" />
                    <input className="button-primary search-button" type="submit" value="Search" onClick={this.search}/>
                  </div>
                </div>
                <div className="poster-container">
                  {posters}
                </div>
              </div>
    } else {
      return <div className="row">
              <div className="four columns offset-by-four not-found-msg">
                No movies yet! :(
              </div>
            </div>
    }

  }
});
