const assert = require('assert');
const path = require('path');
const supertest = require('supertest');
const app = require('../index'); 
const jwt = require('jsonwebtoken');
const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

describe('Image Controller', () => {
  it('should upload an image', async function () {
    this.timeout(10000);

    // Log in to get a token
    const loginResponse = await supertest(app)
      .post('/auth/login')
      .send({
        email: 'lama@se.com',
        password: 'ali1234',
      });

    const token = loginResponse.body.token;
    const decodedToken = jwt.decode(token);
    const userId = decodedToken.id;
    const imagePath = path.resolve(__dirname, './test-img.jpg');

    // Upload profile picture
    const response = await supertest(app)
      .post(`/api/users/${userId}/profile-picture`)
      .attach('profilePicture', imagePath)
      .set('Authorization', `Bearer ${token}`);

    assert.strictEqual(response.status, 201);
    assert.strictEqual(response.body.message, 'Profile picture uploaded successfully');
    assert.strictEqual(typeof response.body.imageUrl, 'string');

    const user = await prisma.user.findUnique({
      where: { id: userId },
    });

    assert.strictEqual(user.profilePicture, response.body.imageUrl);
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
