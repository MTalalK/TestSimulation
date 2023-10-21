<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="SigninSignup.aspx.cs" Inherits="TestSimul.SigninSignup" %>
<asp:Content ID="SigninSignupHeader" ContentPlaceHolderID="head" runat="server">
    <link href="thedatepicker-master/dist/the-datepicker.css" rel="stylesheet" />
    <script src="thedatepicker-master/dist/the-datepicker.js"></script>
</asp:Content>
<asp:Content ID="SigninSignupBody" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
            <Services>
                <asp:ServiceReference Path="~/AJAX.asmx" />
            </Services>
    </asp:ScriptManager>
    <div id="LoginSignup" class="gridlogin">
        <div id="Signin" class="Logindivs">
            <p style="text-align:center; margin-top:5%; background-color:aqua; border:2px solid blue">
                Login
            </p>
            <input id="Email1" type="text" placeholder="Email" style="margin-bottom:5%; width:100%" value="" /><br />
            <input id="Password1" type="password" placeholder="Password" style="margin-bottom:10%; display:flex; width:100%"/>
            <input id="Loginbtn" type="button" value="Sign in" class="btn-primary" style="width:50%; margin-inline:25%;margin-bottom:10%" onclick="GetScores()"/>
            <a id="ForgotPassword" href="ResetPassword.aspx" style="width:50%;margin-inline:16%">Forgot Password?</a>
            <asp:Button ID="Loginbtn1" runat="server" Text="Button" ClientIDMode="Static" OnClick="LoginRedirect" style="display:none;"/>
        </div>
        <div id="Signup" class="Logindivs" style="padding-bottom:5%">
            <p style="text-align:center; margin-top:5%; background-color:aqua; border:2px solid blue">
                Signup
            </p>
            <input id="Name" type="text" placeholder="Name" style="margin-bottom:5%; width:100%" maxlength="15"/><br />
            <input id="DOB" type="text" placeholder="Date of Birth" style="margin-bottom:5%; width:100%"/><br />
            <input id="Email2" type="text" placeholder="Email" style="margin-bottom:5%; width:100%"/><br />
            <input id="Password2" type="password" placeholder="Password" style="margin-bottom:8%; width:100%"/>
            <input id="ConfirmPassword2" type="password" placeholder="Confirm Password" style="margin-bottom:8%; width:100%"/>
            <input id="Signupbtn" type="button" value="Signup" class="btn-primary" style="width:50%; margin-inline:25%" onclick="Submitform()"/>
            <asp:Button ID="Signupbtn1" runat="server" Text="Button" OnClick="SignupRedirect" ClientIDMode="Static" style="display:none;"/>
        </div>
    </div>
    <input id="downloadfile" name="downloadfile" type="hidden" value="" />
    <dialog id="signuperror" style="width:20%;border:2px solid;border-color:orangered">
       <p id="errormessage"style="width:100%; text-align:center">
       </p>
        <input id="Oktbn" type="button" value="Ok" class="btn-primary" style="width:30%; margin-inline:35%" onclick="closedialog()"/>
    </dialog>
    <iframe id="framepdf" name="framepdf" style="display:none"></iframe>
    <script type="text/javascript">
        document.getElementById("Signoutdiv").style.display = "none";
        const input = document.getElementById('DOB');
        const datepicker = new TheDatepicker.Datepicker(DOB);
        datepicker.render();
        var res;
        function Signupvalidator(name, email, password, confirmpassword, dob) {
            SendRequest();
            var modal = document.getElementById("signuperror");
            var errormessage = document.getElementById("errormessage");
            if (name == "" || email == "" || password == "" || confirmpassword == "" || dob == "") {
                errormessage.textContent = "Please fill the required information!";
                modal.showModal();
                return false;
            }
            else if (email.match(/@([a-z]+)(\.)com/) == null) {
                errormessage.textContent = "Please enter correct email address!"
                modal.showModal();
                return false;
            }
            else if (password != confirmpassword) {
                errormessage.textContent = "Passwords are not matching!"
                modal.showModal();
                return false;
            }
            else {
                return true;
            }
        }

        function closedialog() {
            var modal = document.getElementById("signuperror");
            modal.close();
        }

        function Login() {
            var email = document.getElementById("Email1").value;
            var password = document.getElementById("Password1").value;
            TestSimul.AJAX.UserSignin(email, password, LoginCallback);
        }

        function Signup() {
            var name = document.getElementById("Name").value;
            var email = document.getElementById("Email2").value;
            var password = document.getElementById("Password2").value;
            var confirmpassword = document.getElementById("ConfirmPassword2").value;
            var dob = document.getElementById("DOB").value.replace(/.\s/g, "/");
            if (dob.indexOf("/") < 2) {
                dob = "0" + dob;
            }
            if (dob.indexOf("/", 3) < 5) {
                dob = dob.substring(0, 3) + "0" + dob.substring(3);
            }
            if (parseInt(dob.substring(5)) < 1800) {
                dob = dob.substring(0, 6) + "1800";
            }
            var validationfailed = Signupvalidator(name, email, password, confirmpassword, dob);
            if (validationfailed) {
                TestSimul.AJAX.UserSignup(name, dob, email, password, LoginCallback);
            }
            
        }
        async function SendRequest() {
            var data = {
                Email: "tk@gmail.com",
                Password:"sa"
            }
            //window.location.pathname+"/GetScores"
            //"https://localhost:8085/api/Values/GetToken"
            const response = await fetch("https://localhost:8085/api/Values/GetToken", {
                method: "POST", // *GET, POST, PUT, DELETE, etc.
                mode: "cors", // no-cors, *cors, same-origin
                cache: "default", // *default, no-cache, reload, force-cache, only-if-cached
                credentials: "omit", // include, *same-origin, omit
                headers: {
                    "Content-Type": "application/json"
                    // 'Content-Type': 'application/x-www-form-urlencoded',
                },
                redirect: "follow", // manual, *follow, error
                referrerPolicy: "no-referrer", // no-referrer, *no-referrer-when-downgrade, origin, origin-when-cross-origin, same-origin, strict-origin, strict-origin-when-cross-origin, unsafe-url
                body: JSON.stringify(data) // body data type must match "Content-Type" header
            }).then((value) => {
                //console.log(value.json());
                return value;
                //sessionStorage.setItem("token", value.json());
            }
            );

            res = await response.json();
            console.log(res);
        }
        async function GetScores() {
            //console.log(res.value.token);
            let newtoken = res?.value?.token ?? "1212";
            const newresponse = await (fetch("https://localhost:8085/api/Values/GetScores?Candidate=16", {
                method: "GET", // *GET, POST, PUT, DELETE, etc.
                mode: "cors", // no-cors, *cors, same-origin
                cache: "no-cache", // *default, no-cache, reload, force-cache, only-if-cached
                credentials: "omit", // include, *same-origin, omit
                headers: {
                    "Content-Type": "application/json",
                    "Authorization": "bearer " + newtoken,
                    "Accept": "application/json"
                    // 'Content-Type': 'application/x-www-form-urlencoded',
                },
                redirect: "follow", // manual, *follow, error
                referrerPolicy: "no-referrer", // no-referrer, *no-referrer-when-downgrade, origin, origin-when-cross-origin, same-origin, strict-origin, strict-origin-when-cross-origin, unsafe-url
            }));
            console.log(await newresponse);
            GetFile();
        }
        async function GetFile() {
            console.log(res.value.token);
            const newresponse = await (fetch("https://localhost:8085/api/Values/GetFile?filename=image.png", {
                method: "GET", // *GET, POST, PUT, DELETE, etc.
                mode: "cors", // no-cors, *cors, same-origin
                cache: "no-cache", // *default, no-cache, reload, force-cache, only-if-cached
                credentials: "omit", // include, *same-origin, omit
                headers: {
                    "Content-Type": "application/json",
                    "Authorization": "bearer " + res.value.token,
                    "Accept": "application/json"
                    // 'Content-Type': 'application/x-www-form-urlencoded',
                },
                redirect: "follow", // manual, *follow, error
                referrerPolicy: "no-referrer", // no-referrer, *no-referrer-when-downgrade, origin, origin-when-cross-origin, same-origin, strict-origin, strict-origin-when-cross-origin, unsafe-url
            }));
            var jsonresult = await newresponse.json()
            console.log(await jsonresult);
            downloadfile(await jsonresult);
        }
        function downloadfile(resultByte) {
            let decodedbytes = atob(resultByte.fileContents);
            
            var bytes = new Uint8Array(decodedbytes.length); // pass your byte response to this constructor

            for (let i = 0; i < decodedbytes.length; i++) {
                bytes[i] = decodedbytes.charCodeAt(i);
            }
            //const bytes = Uint8Array.from(atob(resultByte.fileContents), c => c.charCodeAt(0));
            var blob = new Blob([bytes], { type: "image/png" });// change resultByte to bytes

            var link = document.createElement('a');
            link.href = window.URL.createObjectURL(blob);
            link.download = "Image.png";
            link.click();
        }
        function Submitform() {
            document.getElementById("downloadfile").value = "Downloadfile";
            let form = document.getElementById("form1");
            form.action = "DownloadPdf.aspx";
            form.target = "framepdf";
            form.submit();
        }
    </script>
    <script type="text/javascript" src="Scripts/WebServiceCallBacks.js"></script>"
</asp:Content>
