const taskRepository = require("../repositories/taskRepository");


function getTasks(req, res) {

    const userId = req.user.id;


    const tasks = taskRepository.getTasksByUserId(
        userId
    );


    res.json(tasks);

}


module.exports = {
    getTasks
};