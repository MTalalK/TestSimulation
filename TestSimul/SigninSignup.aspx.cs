using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;

namespace TestSimul
{
    public partial class SigninSignup : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public void LoginRedirect(object sender, EventArgs e)
        {
            string Url = "~/StartTestPage.aspx";
            string USERID = Session["UserID"] != null ? "?UserID=" + Session["UserID"].ToString() : string.Empty;
            Response.Redirect(Url + USERID);
        }
        public void SignupRedirect(object sender, EventArgs e)
        {

        }

        [WebMethod(EnableSession=true)]
        public static string GetScores()
        {
            return "";
        }
    }
}