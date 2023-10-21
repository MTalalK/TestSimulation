<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="ResetPassword.aspx.cs" Inherits="TestSimul.ResetPassword" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
            <Services>
                <asp:ServiceReference Path="~/AJAX.asmx" />
            </Services>
    </asp:ScriptManager>
    <div id="forgotpassworddiv" class="gridlogin" style="grid-template-columns:1fr; margin-inline:40%">
        <div id="forgotpass" class="Logindivs">
            <p style="text-align:center; margin-top:5%; background-color:aqua; border:2px solid blue">
                Reset Password
            </p>
            <input id="Email" type="text" placeholder="Email" style="margin-bottom:5%; width:100%" value="" /><br />
            <dialog id="signuperror" style="width:20%;border:2px solid;border-color:orangered">
                <p id="errormessage"style="width:100%; text-align:center">
                    No user found against the given email!
                </p>
                <input id="Oktbn" type="button" value="Ok" class="btn-primary" style="width:30%; margin-inline:35%" onclick="closedialog()"/>
            </dialog>
            <input id="SendCodebtn" type="button" value="Send Code" class="btn-primary" style="margin-bottom:5%;width:50%; margin-inline:25%" onclick="SendCode()"/>
            <div id="codediv">
                <div id="codediv1" style="width:40%;display:inline-block;margin-left:30%">
                    <input id="code" class="" type="text" placeholder="Code" style="margin-bottom:5%;width:100%;" maxlength="6" />
                </div>
                <div style="display:inline-block;width:10%;">
                    <div class="trigger"></div>
                    <svg version="1.1" id="tick" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
	                    viewBox="0 0 37 37" style="" xml:space="preserve">
                        <path class="circ path" style="fill:none;stroke:blue;stroke-width:3;stroke-linejoin:round;stroke-miterlimit:10;" d="
	                    M30.5,6.5L30.5,6.5c6.6,6.6,6.6,17.4,0,24l0,0c-6.6,6.6-17.4,6.6-24,0l0,0c-6.6-6.6-6.6-17.4,0-24l0,0C13.1-0.2,23.9-0.2,30.5,6.5z"
	                    />
                        <polyline class="tick path" style="fill:none;stroke:forestgreen;stroke-width:3;stroke-linejoin:round;stroke-miterlimit:10;" points="
	                    11.6,20 15.9,24.2 26.4,13.8 "/>
                </svg>
                </div>
            </div>
            <input id="Hiddencode" type="hidden" />
            <input id="password" type="password" placeholder="Password" style="margin-bottom:5%; width:100%" disabled="disabled" />
            <input id="confirmpassword" type="password" placeholder="Confirm Password" style="margin-bottom:5%; width:100%" disabled="disabled" />
            <input id="UpdatePasswordbtn" type="button" value="Update Password" class="btn-primary" style="margin-bottom:5%;width:70%; margin-inline:15%" onclick=""/>
            <a id="backtologin" href="SigninSignup.aspx" style="margin:25%; margin-bottom:5%" >Back To Login</a>
        </div>
    </div>
    <script type="text/javascript">
        document.getElementById("Signoutdiv").style.display = "none";
        document.getElementById("code").oninput = function () {
            var hiddencode = document.getElementById("Hiddencode").value;
            if (event.target.value == hiddencode) {
                //document.getElementById("codediv").classList.add("Verified");
                //$(".trigger").toggleClass("drawn")
                document.getElementsByClassName("trigger")[0].classList.add("drawn");
                document.getElementById("code").style.borderColor = "limegreen";
                document.getElementById("code").disabled = "disabled";
                document.getElementById("password").disabled = "";
                document.getElementById("password").focus();
                document.getElementById("confirmpassword").disabled = "";
            }
        }
        function SendCode() {
            var Email = document.getElementById("Email").value.trim();
            if (Email == "") {
                var modal = document.getElementById("signuperror");
                var errortext = document.getElementById("errormessage");
                errortext.textContent = "Please enter an email";
                modal.showModal();
            }
            else {
                TestSimul.AJAX.SendingCode(Email, SendCodecallback);
            }
        }
        function closedialog() {
            var modal = document.getElementById("signuperror");
            modal.close();
        }
        function UpdatePassword() {

        }
    </script>
</asp:Content>
