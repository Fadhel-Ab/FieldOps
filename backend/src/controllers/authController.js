const authService = require("../services/authService");


async function login(req, res) {

    try {

        const { email, password } = req.body;


        const result = await authService.login(
            email,
            password
        );


        res.json(result);


    } catch (error) {

        res.status(401).json({
            message: error.message
        });

    }

}


module.exports = {
    login
};