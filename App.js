/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 */

import React from 'react';

import * as eva from '@eva-design/eva';
import { ApplicationProvider, Layout, Text } from '@ui-kitten/components';

import {
  SafeAreaView,
  StyleSheet,
  ScrollView,
  View,
  StatusBar,
  Linking,
  Component,
} from 'react-native';
import ShareMenu from 'react-native-share-menu';


class App extends React.Component {
  constructor(props) {
    super(props); 
    this.state = {
      sharedText: null,
      sharedImage: null
    };
  }
// _UNSAFE_componentWillMount() {
  componentDidMount () {
   if(Platform.OS === 'ios'){
      Linking.addEventListener('url', this.handleOpenURL);
      var that = this;
      ShareMenu.getSharedText((text :string) => {
        if (text && text.length) {
          if (text.startsWith('content://media/')) {
            that.setState({ sharedImage: text });
          } else {
that.setState({ sharedText: text.replace("test.app.link://App/", "") });
          }
        }
      })
    }
    else{
    var that = this;
    ShareMenu.getSharedText((text :string) => {
      if (text && text.length) {
        if (text.startsWith('content://media/')) {
          that.setState({ sharedImage: text });
        } else {
          that.setState({ sharedText: text.replace("test.app.link://App/", "") });
        }
      }
    })
    }
  }

componentWillUnmount () {
      Linking.removeEventListener('url', this.handleOpenURL);
}

handleOpenURL = (event) => {
console.log('linking',event)

var that = this;
that.setState({ sharedText: event.url.replace("test.app.link://App/", "") });
console.log(event.url)

}
  render() {
    var text = this.state.sharedText;
    return (
       <ApplicationProvider {...eva} theme={eva.dark}>
        <Layout style={{flex: 1, justifyContent: 'center', alignItems: 'center'}}>
          <Text category='h1'>Shared text: {text}</Text>
        </Layout>
  </ApplicationProvider>
    );
  }
}

export default App
