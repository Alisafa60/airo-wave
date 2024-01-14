const { PrismaClient } = require("@prisma/client");
const { handleError } = require("../../helpers");
const prisma = new PrismaClient();
const bcrypt = require('bcrypt');

const hashPassword = async (password) => {
    const salt = await bcrypt.genSalt(10);
    return bcrypt.hash(password, salt);
};

const updateProfile = async (req, res) => {
    try {
      const userId = req.user.id;
      const { firstName, lastName, gender, unit, phone, adress } = req.body;
      console.log('Incoming Update Profile Request:', req.body);
      const existingUser = await prisma.user.findUnique({ where: { id: userId } });
        
      if (!existingUser) {
        return res.status(404).json({ error: 'User not found' });
      }
  
      const updatedUser = await prisma.user.update({
        where: { id: userId },
        data: {
          firstName: firstName || existingUser.firstName,
          lastName: lastName || existingUser.lastName,
          gender: gender || existingUser.gender,
          unit: unit || existingUser.unit,
          phone: phone || existingUser.phone,
          address: adress || existingUser.address,
        },
      });
      console.log('Updated User:', updatedUser);
      return res.status(200).json({ user: updatedUser });
    } catch (e) {
        handleError(res, e, 'Error updating profile');
    }
};
  
const changePassword = async (req, res) => {
    try {
        const userId = req.user.id;
        const { currentPassword, newPassword } = req.body;

        const user = await prisma.user.findUnique({ where: { id: userId } });

        if (!user) {
        return res.status(404).json({ error: 'User not found' });
        }

        const isPasswordValid = await bcrypt.compare(currentPassword, user.password);

        if (!isPasswordValid) {
        return res.status(401).json({ error: 'Invalid current password' });
        }

        const hashedNewPassword = await hashPassword(newPassword);

        await prisma.user.update({
        where: { id: userId },
        data: { password: hashedNewPassword },
        });

        return res.status(200).json({ message: 'Password changed successfully' });
    } catch (e) {
        handleError(res, e, 'Error changing password');
    }
};

const getUserProfile = async (req, res) => {
    try{
        const userId = req.user.id;
        
        const user = await prisma.user.findUnique({
            where:{ id: userId}
        });
        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }

        return res.status(200).json({ user });
    } catch (e) {
        handleError(res, e, 'Error retrieving user profile');
    }
}

module.exports = {
    updateProfile,
    changePassword,
    getUserProfile,
}