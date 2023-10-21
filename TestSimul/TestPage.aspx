<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="TestPage.aspx.cs" Inherits="TestSimul.TestPage" %>
<asp:Content ID="TestPageHeader" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    
    
     <script type="text/javascript">
         document.getElementById("Signoutdiv").style.display = "block";
        //This func displays the first question on pageload
        $(document).ready(function () {
            TestSimul.AJAX.GetQuestionsandOptions(0, 0, 1, Success);
            StartTimer();
        });
        //Runs the webservice to recieve the questions and options from the db on the click of next and previous button
         function GetQuestion(IID) {
             window.event.target.blur();
            var SelectedOption = document.getElementsByName('OptionList');
            var OptionValue = 'x';
            for (i = 0; i < SelectedOption.length; i++) {
                if (SelectedOption[i].checked) {
                    OptionValue = SelectedOption[i].value;
                    break;
                }
            }
            TestSimul.AJAX.GetQuestionsandOptions(IID, OptionValue, 0, Success);
        }
        //This func updates the question and options and disables and enables the buttons
         function Success(Info) {
             var Options = Info["Options"]
             for (var i = 0; i < Options.length; i++) {
                 if (document.getElementsByName('OptionList').length < Options.length) {
                     var NewOptionnumber = document.getElementsByName('OptionList').length + i;
                     var Newoptiondiv = document.createElement("div");
                     Newoptiondiv.classList.add("form-check");
                     Newoptiondiv.setAttribute("name", "Optionsdiv");
                     var NewOptionid = "Option" + NewOptionnumber + "div";
                     Newoptiondiv.id = NewOptionid;
                     var Newoption = document.createElement("input");
                     Newoption.classList.add("form-check-input");
                     Newoption.id = "Option" + NewOptionnumber;
                     Newoption.type = "radio";
                     Newoption.name = "OptionList";
                     var Newoptionlabel = document.createElement("label");
                     Newoptionlabel.setAttribute("for", Newoption.id);
                     Newoptionlabel.classList.add("form-check-label");
                     Newoptionlabel.setAttribute("name", "Labels");
                     Newoptionlabel.textContent = "NewOption";
                     Newoptiondiv.appendChild(Newoption);
                     Newoptiondiv.appendChild(Newoptionlabel);
                     document.getElementById("Options").appendChild(Newoptiondiv);
                 }
                 else if (document.getElementsByName('OptionList').length > Options.length) {
                     var j = document.getElementsByName('OptionList').length - 1;
                     let node = document.getElementsByName('Optionsdiv')[j];
                     node.remove();
                 }
                 else {
                     break;
                 }
             }
             //else if ()
             document.getElementById('QuestionStatement').innerText = Info["CurrentQStatement"];
             
             for (var i = 0; i < Options.length; i++) {
                 document.getElementsByName("OptionList")[i].value = Options[i];
                 document.getElementsByName("Labels")[i].textContent = Options[i];
             }
            
             //document.querySelector("label[for='Option4']").textContent = "None of These";
            for (i = 0; i < document.getElementsByName('OptionList').length; i++) {
                document.getElementsByName('OptionList')[i].checked = false;
            }
            if (Info["QuestionisAnswered"]) {
                for (i = 0; i < document.getElementsByName('OptionList').length; i++) {
                    if (document.getElementsByName('OptionList')[i].value == Info["SelectedAnswer"]) {
                        document.getElementsByName('OptionList')[i].checked = true;
                    }
                }
            }
            if (parseInt(Info["CurrentQID"]) == 1) {
                document.getElementById("Previous_btn").disabled = true;
                document.getElementById("Next_btn").disabled = false;
                
            }
            else if (parseInt(Info["CurrentQID"]) == parseInt(Info["TotalQuestionCount"])) {
                document.getElementById("Next_btn").disabled = true;
                
            }
            else {
                document.getElementById("Previous_btn").disabled = false;
                document.getElementById("Next_btn").disabled = false;
            }
        }
        let timeleft = 300; //Set the time for the test
        var interval;//Value of this variable is set in the StartTimer func. This is the interval on which the time is updated
        //After time is up, execute this function which stores data and redirects to next page
        function completed() {
            Submit(0);
            clearInterval(interval);
            document.getElementById('<%= Timer_btn.ClientID %>').click();
        }
     </script>
</asp:Content>
<asp:Content ID="TestPageBody" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
            <Services>
                <asp:ServiceReference Path="~/AJAX.asmx" />
            </Services>
        </asp:ScriptManager>
        <br />
        <div class="container">

        </div>
        <div class="container float-right w-auto">
            <div id="Timerdiv" class="container w-auto bg-primary text-white border border-dark">
                <label ID="Timer" Text=""></label>
            </div>
            &nbsp
        </div>
        <div class="container align-content-center w-50 border border-primary">
            <div class="form-group" id="QuestionStatement">
                x
            </div>
            <div id="Options" class="form-group">
                <div class="form-check" name="Optionsdiv">
                    <input id="Option0" class="form-check-input" type="radio" name="OptionList" value=""/>
                    <label for="Option0" class="form-check-label" name="Labels"></label>
                </div>
                <div class="form-check" name="Optionsdiv">
                    <input id="Option1" class="form-check-input" type="radio" name="OptionList" value=""/>
                    <label for="Option1" class="form-check-label" name="Labels"></label>
                </div>
                <div class="form-check" name="Optionsdiv">
                    <input id="Option2" class="form-check-input" type="radio" name="OptionList" value=""/>
                    <label for="Option2" class="form-check-label" name="Labels"></label>
                </div>
                
            </div>
            <div class="container clearfix">
                <div class="form-group w-auto float-left">
                    <button class="btn-outline-success text-center disableenablecss" type="button" onclick="GetQuestion(0)" causesvalidation="False" id="Previous_btn" style="width:80px;">Previous</button>
                    <button class="btn-outline-success text-center disableenablecss" type="button" onclick="GetQuestion(1)" causesvalidation="False" id="Next_btn" style="width:70px;">Next</button>
                </div>
                <div class="form-group w-auto float-right">
                    <asp:Button class="btn-primary" ID="Submit_btn" runat="server" OnClientClick="return Submit(1);" Text="Submit Test" CausesValidation="False" ClientIDMode="Static" OnClick="Redirect" />
                </div>
            </div>
        </div>
    
        
        
            <asp:Button ID="Timer_btn" runat="server" Text="Lol" CausesValidation="False" ClientIDMode="Static" OnClick="Redirect" style="visibility:hidden;"/>
</asp:Content>
