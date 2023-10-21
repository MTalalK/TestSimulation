<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="StartTestPage.aspx.cs" Inherits="TestSimul.StartTestPage" %>
<asp:Content ID="HeaderStartTest" ContentPlaceHolderID="head" runat="server">
        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</asp:Content>
<asp:Content ID="Body1StartTest" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
            <Services>
                <asp:ServiceReference Path="~/AJAX.asmx" />
            </Services>
        </asp:ScriptManager>
    <br />
    <div class="container w-50">
        <div class="container border border-success">
        <div class="row justify-content-center" >
            <asp:Label ID="StartTestInstructions" runat="server" Text="Please click on the following button in order to start the test"></asp:Label>
        </div>
        <br />
        <div class="row justify-content-center">
             <asp:Button class="btn-outline-success" ID="StartTestbtn" runat="server" Text="Start Test" OnClick="GoToTest"></asp:Button>
        </div>
        <br />
        </div>
    </div>
    
    
    <script type="text/javascript">
        document.getElementById("Signoutdiv").style.display = "block";
        $(document).ready(function () {
            TestSimul.AJAX.PrepareTest();
        });
        const queryString = window.location.search;
        const urlParams = new URLSearchParams(queryString);
        var ApiUrl = "https://localhost:8085/api/Values/GetScores";
        ApiUrl = urlParams.get("UserID") != null && urlParams.get("UserID") != undefined ? ApiUrl + "?Candidate=" + urlParams.get("UserID") : ApiUrl
        fetch(ApiUrl).then(response => { console.log(response.json()) });

    </script>
</asp:Content>
