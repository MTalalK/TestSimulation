//Starts timer after being called onload
function StartTimer() {
    interval = setInterval(CountDown, 1000);
}

//Countdown func is called on each interval. It updates the time and after the timesup, executes complete func
function CountDown() {
    if (timeleft > 0) {
        if (timeleft < 20) {
            document.getElementById("Timerdiv").classList.remove("bg-primary");
            document.getElementById("Timerdiv").classList.add("bg-danger");
        }
        update(timeleft);
    }
    else {
        update(timeleft);
        completed();
    }
}
//Update Time
function update(time) {
    var hours = Math.floor(time / 3600);
    var minutes = Math.floor((time % 3600) / 60);
    var seconds = time % 60;
    document.getElementById('Timer').innerHTML = 'Time Left:  ' + hours + ' : ' + minutes + ' : ' + seconds;
    timeleft--;
}
