/*
Copyright 2017 - 2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at
    http://aws.amazon.com/apache2.0/
or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and limitations under the License.
*/

var express = require('express')
const axios = require('axios').default
var awsServerlessExpressMiddleware = require('aws-serverless-express/middleware')
const AWS = require('aws-sdk');
const cognitoidentityserviceprovider = new AWS.CognitoIdentityServiceProvider({
  apiVersion: '2016-04-18',
  region: 'ap-northeast-2',
});

// declare a new express app
var app = express()
app.use(express.json())
app.use(awsServerlessExpressMiddleware.eventContext())

// Enable CORS for all methods
app.use(function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*")
  res.header("Access-Control-Allow-Headers", "*")
  next()
});


/**********************
 * Example get method *
 **********************/

app.get('/user/login', function(req, res) {
  // Add your code here
  res.json({success: 'get call succeed!', url: req.url});
});

app.get('/user/login/*', function(req, res) {
  // Add your code here
  res.json({success: 'get call succeed!', url: req.url});
});

/****************************
* Example post method *
****************************/

app.post('/user/login', async function(req, res) {
  console.log('req.body:', JSON.stringify(req.body, null, 2));
  const { access_token } = req.body || {};
  const kakaoAuthUrl = 'https://kapi.kakao.com/v2/user/me';
  const kakaoAuthOptions = {
    headers: {
      Authorization: `Bearer ${access_token}`
    },
  };
  const axiosRes = await axios.get(kakaoAuthUrl, kakaoAuthOptions);
  console.log('axios res:', axiosRes);
  const { status, data } = axiosRes;
  if (status > 200) {
    res.json({
      success: 'post call failed!',
      url: req.url,
      body: req.body,
      axiosRes: axiosRes.data
    });
    return;
  }
  const GroupName = 'Kakao';
  const UserPoolId = 'ap-northeast-2_FHkKRu1Gm';  // aws-exports.js의 "aws_user_pools_id"
  const ClientId = 'd101ph15dc5ji69i165efm58q'; // aws-exports.js "aws_user_pools_web_client_id"
  // const Username = 'kakao_' + data.id;
  const Username = data.kakao_account.email;
  console.log(Username);
  const newUserParam = {
    ClientId,
    Username,
    Password: 'Kakao' + data.id.toString() + '!',
    ClientMetadata: {
      UserPoolId,
      Username,
      GroupName,
    },
    UserAttributes: [
      {
        Name: 'email' /* required */,
        Value: data.kakao_account.email,
      },
      {
        Name: 'name',
        Value: 'kakao_' + data.id,
      },
    ],
  };
  
  const getSignUpRes = async () => {
    try {
    const signUpRes = await cognitoidentityserviceprovider.signUp(newUserParam).promise();
    return signUpRes;
  } catch (e) {
    console.log(e);
      switch (e.toString().split(':')[0]) {
        case "UsernameExistsException":
          return true;
        default:
          throw e;
      }
  }}

  signUpRes = await getSignUpRes();

  console.log('signUpRes', signUpRes)// accessToken, idToken, refreshToken

  // var signInRes = await axios.get();
    
  var signInRes = await cognitoidentityserviceprovider.adminInitiateAuth(
    {
      "AuthFlow": "ADMIN_NO_SRP_AUTH",
      "ClientId": ClientId,
      "UserPoolId": UserPoolId,
      "AuthParameters": {
        "USERNAME": Username,
        "PASSWORD": 'Kakao' + data.id.toString() + '!',
      }
    }
  ).promise();

  console.log('signInRes: ', signInRes);

  res.json({
    success: 'post call succeed!',
    url: req.url,
    body: req.body,
    signUpRes,
    AuthenticationResult: signInRes["AuthenticationResult"],
    password: 'Kakao' + data.id.toString() + '!',
  });
});

app.post('/user/login/*', function(req, res) {
  // Add your code here
  res.json({success: 'post call succeed!', url: req.url, body: req.body})
});

/****************************
* Example put method *
****************************/

app.put('/user/login', function(req, res) {
  // Add your code here
  res.json({success: 'put call succeed!', url: req.url, body: req.body})
});

app.put('/user/login/*', function(req, res) {
  // Add your code here
  res.json({success: 'put call succeed!', url: req.url, body: req.body})
});

/****************************
* Example delete method *
****************************/

app.delete('/user/login', function(req, res) {
  // Add your code here
  res.json({success: 'delete call succeed!', url: req.url});
});

app.delete('/user/login/*', function(req, res) {
  // Add your code here
  res.json({success: 'delete call succeed!', url: req.url});
});

app.listen(3000, function() {
    console.log("App started")
});

// Export the app object. When executing the application local this does nothing. However,
// to port it to AWS Lambda we will create a wrapper around that will load the app from
// this file
module.exports = app
