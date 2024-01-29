const assert = require('assert');
const path = require('path');
const supertest = require('supertest');
const app = require('../index'); 
const jwt = require('jsonwebtoken');
const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

describe('Image Controller', () => {
 

  it('should log in and fail to upload an image with missing image attachment', async function () {
    this.timeout(10000);

    const loginResponse = await supertest(app)
      .post('/auth/login')
      .send({
        email: 'ali@se.com',
        password: 'ali1234',
      });

    const token = loginResponse.body.token;

    const response = await supertest(app)
      .post(`/api/user/profile-picture`)
      .set('Authorization', `Bearer ${token}`);

    assert.strictEqual(response.status, 400); 
    assert.strictEqual(response.body.error, 'No image uploaded.');  
  });

    it('should log in and fail to upload an image with disallowed extension', async function () {
      this.timeout(10000);
  
      const loginResponse = await supertest(app)
        .post('/auth/login')
        .send({
          email: 'ali@se.com',
          password: 'ali1234',
        });
  
      const token = loginResponse.body.token;
      const imagePath = path.resolve(__dirname, './test-image.txt');  
  
      const response = await supertest(app)
        .post(`/api/user/profile-picture`)
        .attach('profilePicture', imagePath)
        .set('Authorization', `Bearer ${token}`);
  
      assert.strictEqual(response.status, 500);  
      assert.strictEqual(response.body.error, undefined);
    });

});

// describe('Image Controller', () => {
//   it('should delete the profile picture', async function () {
//     this.timeout(10000);

//     const loginResponse = await supertest(app)
//       .post('/auth/login')
//       .send({
//         email: 'lama@se.com',
//         password: 'ali1234',
//       });

//     const token = loginResponse.body.token;
//     const decodedToken = jwt.decode(token);
//     const userId = decodedToken.user_id;

//     // Delete profile picture
//     const deleteResponse = await supertest(app)
//       .delete(`/api/users/${userId}/profile-picture`)
//       .set('Authorization', `Bearer ${token}`);

//     if (deleteResponse.status === 204) {
//       assert.strictEqual(deleteResponse.status, 204);
//     } else if (deleteResponse.status === 404) {
//       assert.strictEqual(deleteResponse.status, 404);
//       assert.strictEqual(deleteResponse.body.message, 'No profile picture to delete.');
//     } else {
//       assert.fail(`Unexpected status: ${deleteResponse.status}`);
//     }
//   });
// });
