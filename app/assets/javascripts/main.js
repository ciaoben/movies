require('../stylesheets/skeleton/css/normalize.css');
require('../stylesheets/skeleton/css/skeleton.css');
require('../stylesheets/body.scss');
import React from 'react';
import ReactDOM from 'react-dom';
import Home from './containers/Home';

ReactDOM.render(
  <Home />,
document.querySelector('#container')
);
