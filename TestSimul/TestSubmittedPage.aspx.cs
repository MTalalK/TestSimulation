using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TestSimul
{
    public partial class TestSubmittedPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string con = System.Configuration.ConfigurationManager.ConnectionStrings["YIP"].ConnectionString;
            string DisplayScore;
            using (SqlConnection Connection = new SqlConnection(con))
            {

                Connection.Open();
                SqlCommand CommandShowingScore = new SqlCommand("ShowingScore", Connection);
                CommandShowingScore.CommandType = CommandType.StoredProcedure;

                CommandShowingScore.Parameters.AddWithValue("@CandidateID", Convert.ToInt32(Session["UserID"]));
                Score.Text = CommandShowingScore.ExecuteScalar().ToString();
                DisplayScore = Score.Text + " out of 20";
                Connection.Close();
            }
            if (Convert.ToInt32(Score.Text) <= 10)
            {
                Score.ForeColor = Color.Red;
            }
            else
            {
                Score.ForeColor = Color.LightSeaGreen;
            }
            Score.Text = DisplayScore;
        }
        public void Take_Test(object sender, EventArgs e)
        {
            Response.Redirect("~/StartTestPage.aspx");
        }
    }
}