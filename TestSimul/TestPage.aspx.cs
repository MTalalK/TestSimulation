using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TestSimul
{
    public partial class TestPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        public void Redirect(object sender, EventArgs e)
        {
            Response.Redirect("~/TestSubmittedPage.aspx");
        }
    }
}