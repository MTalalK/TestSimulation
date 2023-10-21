<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="TestSubmittedPage.aspx.cs" Inherits="TestSimul.TestSubmittedPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <div class="container justify-content-center">
             <div class=" text-lg-center text-primary">Test Completed
        </div>
        <div class=" text-lg-center">
            Your Score is: <asp:Label class="font-weight-bold" ID="Score" runat="server" Font-Size="Larger"></asp:Label>
        </div>
        <br />
        <div class="row justify-content-center">
            <asp:Button class="btn-primary" ID="Again_TakeTest" runat="server" Text="Try Again" OnClick="Take_Test"/>
        </div>
        </div>
    <script>
        document.getElementById("Signoutdiv").style.display = "block";
    </script>
</asp:Content>
