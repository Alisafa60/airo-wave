// Import Prisma Client
import { PrismaClient, Type as UserType } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
    const user = await prisma.user.create({
        data:{
            email:'ali@hotmail.com',
            firstName:'ali',
            lastName:'safa',
            gender:'male',
            password:'ali1234',
            unit:'Metric',
            userTypeId:2,
        }
    })
}

main()
    .catch((e:Error)=>{
        console.error(e);
        process.exit(1);
    })
    .finally(async () =>{
        await prisma.$disconnect();
    })

// const userTypesData = [
//   { type: 'admin' as UserTypeType },
//   { type: 'user' as UserTypeType },
//   { type: 'healthProfessional' as UserTypeType },
// ];


// async function seedUserTypes() {
//   try {
//     await Promise.all(
//       userTypesData.map(async (userData) => {
//         await prisma.userType.create({
//           data: {
//             type: userData.type,
//           },
//         });
//       })
//     );

//     console.log('UserType data seeded successfully');
//   } catch (error) {
//     console.error('Error seeding UserType data:', error);
//   } finally {
//     await prisma.$disconnect();
//   }
// }

// seedUserTypes();


