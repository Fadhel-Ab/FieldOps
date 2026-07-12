const taskRepository = require("../repositories/taskRepository");


function getTasks(req, res) {

    const userId = req.user.id;


    const tasks = taskRepository.getTasksByUserId(
        userId
    );


    res.json(tasks);

}
function updateTask(req, res) {

    const id = Number(req.params.id);

    const updatedTask = taskRepository.updateTask(id, {
        status: req.body.status,
        latitude: req.body.latitude,
        longitude: req.body.longitude,
        image: req.file ? req.file.filename : null
    });

    if (!updatedTask) {
        return res.status(404).json({
            message: "Task not found"
        });
    }

    res.json({
        message: "Task updated successfully",
        task: updatedTask
    });
}
module.exports = {
    getTasks,
    updateTask
};