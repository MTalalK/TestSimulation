<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DownloadPdf.aspx.cs" Inherits="TestSimul.DownloadPdf" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript">
        function Submit() {
            document.getElementById("downloadfile").value = "Downloadfile";
            document.getElementById("form1").submit();
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    </form>
</body>
</html>
