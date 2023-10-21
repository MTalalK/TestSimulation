using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Web.Hosting;
using System.Net;
using IronPdf;

namespace TestSimul
{
    public partial class DownloadPdf : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Convert.ToString(Request.Form["downloadfile"]) == "Downloadfile")
            {
                var Renderer = new ChromePdfRenderer();
                Renderer.RenderingOptions = new ChromePdfRenderOptions() { EnableJavaScript = true, CreatePdfFormsFromHtml = false };
                var PDF =
                Renderer.RenderUrlAsPdf("http://localhost:" + HttpContext.Current.Request.Url.Port + "/SigninSignup.aspx");
                //PDF.SaveAs("E:\\wikipedia.pdf");

                Response.Clear();
                Response.ClearContent();
                Response.ClearHeaders();
                Response.AddHeader("content-disposition", "attachment; filename=PdffromHtml.pdf");
                //Set the content type as file extension type
                Response.ContentType = "application/pdf";
                //Write the file content
                Response.BinaryWrite(PDF.BinaryData);
                this.Response.End();
            }
        }

    }
}