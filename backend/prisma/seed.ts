// Import Prisma Client
import { PrismaClient, Type as UserType } from '@prisma/client';

const prisma = new PrismaClient();

// async function main() {
//     const user = await prisma.user.create({
//         data:{
//             email:'ali1@hotmail.com',
//             firstName:'ali',
//             lastName:'safa',
//             gender:'male',
//             password:'ali1234',
//             unit:'Metric',
//             userTypeId:3,//usertype of admin, with id=1 for user and id=2 for healthprofessional
//         }
//     })
// }

// main()
//     .catch((e:Error)=>{
//         console.error(e);
//         process.exit(1);
//     })
//     .finally(async () =>{
//         await prisma.$disconnect();
//     })

const userTypesData = [
  { type: 'admin' as UserType },
  { type: 'user' as UserType },
  { type: 'healthProfessional' as UserType },
];


async function seedUserTypes() {
  try {
    await Promise.all(
      userTypesData.map(async (userData) => {
        await prisma.userType.create({
          data: {
            type: userData.type,
          },
        });
      })
    );

    console.log('UserType data seeded successfully');
  } catch (error) {
    console.error('Error seeding UserType data:', error);
  } finally {
    await prisma.$disconnect();
  }
}

seedUserTypes();


