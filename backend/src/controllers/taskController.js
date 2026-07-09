const taskRepository = require("../repositories/taskRepository");


function getTasks(req, res) {

    const userId = req.user.id;


    const tasks = taskRepository.getTasksByUserId(
        userId
    );


    res.json(tasks);

}

function updateTask(req, res) {

    const { id } = req.params;

    const {
        status,
        latitude,
        longitude
    } = req.body;

 console.log({
        id,
        status,
        latitude,
        longitude,
        image:req.file
    });

    res.json({
        message:"Task updated successfully"
    });


}
module.exports = {
    getTasks,
    updateTask
};