const supertest = require('supertest');
const assert = require('assert');
const app = require('../index'); 
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
const rewire = require('rewire');

describe('sign up api', () => {
  it('should register a new user successfully', async () => {
    const response = await supertest(app)
      .post('/auth/register')
      .send({
        email: 'test6@se.com',
        password: 'testpassword112',
        firstName: 'ali',
        lastName: 'safa',
        gender: 'male',
        unit: 'Metric',
        type: 'healthProfessional',
      });
      
    assert.strictEqual(response.status, 200);
    assert.strictEqual(response.body.user.email, 'test6@se.com');
 
    const createdUser = await prisma.user.findFirst({ where: { email:'test6@se.com' } });
      assert.strictEqual(createdUser.firstName, 'ali');
      
  });

  it('should handle invalid input', async () => {
    const response = await supertest(app)
      .post('/auth/register')
      .send({
        email: 'abbas@se.com',
        password: 'testpassword',
      });


    assert.strictEqual(response.status, 400);
  
  });
});
