const { PrismaClient } = require("@prisma/client");

const prisma = new PrismaClient();

const addAllergy = async (req, res) => {
    try{
        const userId = req.user.id;
        const {allergen, severity, duration, triggers, medicationFields} = req.body;

        const newAllergy = await prisma.allergy.create({
            data: {
                allergen,
                severity,
                duration,
                triggers,
                medications:{
                    create:{
                        name: medicationFields.name,
                        frequency: medicationFields.frequency || null,
                        dosage: medicationFields.dosage || null,
                        startDate: medicationFields.startDate || null,
                    }
                }
            }
        });
        res.status(201).json({allergy: newAllergy});

    }catch(e){
        console.error("error adding allergy", e);
        res.status(500).json({error: e.message});
    }
}

module.exports ={
    addAllergy,
};
