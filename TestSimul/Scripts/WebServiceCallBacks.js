//Submits the data into db after confirmation
function Submit(AutoSubmit) {
    if (AutoSubmit == 1) {
        var Confirmation = window.confirm("Do you want to submit?");
    }
    else {
        var Confirmation = true;
    }
    if (Confirmation) {
        clearInterval(interval);
        var SelectedOption = document.getElementsByName('OptionList');
        var OptionValue = 'x';
        for (i = 0; i < SelectedOption.length; i++) {
            if (SelectedOption[i].checked) {
                OptionValue = SelectedOption[i].value;
                break;
            }
        }
        TestSimul.AJAX.Submit(OptionValue);
    }
    return Confirmation;
}


function LoginCallback(UserInfo) {
    if (UserInfo["SignupMessage"] == "") {
        if (UserInfo["isPasswordCorrect"]) {
            document.getElementById("Loginbtn1").click();
        }
        else {
            alert("Incorrect Email or Password!");
        }
    }
    else {
        UserExistsCheck(UserInfo);
    }
}

function UserExistsCheck(UserInfo) {
    if (UserInfo["SignupMessage"] == "Name") {
        var modal = document.getElementById("signuperror");
        var errortext = document.getElementById("errormessage");
        errortext.textContent = "User Name already exists! Please use any other User Name.";
        modal.showModal();
    }
    else {
        var modal = document.getElementById("signuperror");
        var errortext = document.getElementById("errormessage");
        errortext.textContent = "Email already exists! Please use any other email.";
        modal.showModal();
    }
}

function SendCodecallback(code) {
    if (code != 0) {
        document.getElementById("Hiddencode").value = code;
    }
    else {
        var modal = document.getElementById("signuperror");
        var errortext = document.getElementById("errormessage");
        errortext.textContent = "No user found against the given email!";
        modal.showModal();
    }
}