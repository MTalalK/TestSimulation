using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TestSimul
{
    [System.Web.Script.Services.ScriptService]
    public partial class ResetPassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //if(Convert.ToInt32(Request["value"]) >= 0)
            //{
            //    return TestAjax();
            //}
        }

        public void LoginRedirect(object sender, EventArgs e)
        {
            Response.Redirect("~/SigninSignup.aspx");
        }

        public int TestAjax()
        {
            return Convert.ToInt32(Request["value"]);
        }
    }
}