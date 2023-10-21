using System;
using System.Collections.Generic;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Script.Serialization;
using System.Security.Cryptography;

namespace TestSimul
{
    /// <summary>
    /// Summary description for AJAX
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class AJAX : WebService
    {
        [WebMethod(EnableSession = true)]
        public CurrentQuestioninfo GetQuestionsandOptions(int PreviousNextID, string SelectedOption, int OnloadPage)
        {
            
            string con = ConfigurationManager.ConnectionStrings["YIP"].ConnectionString;
            List<String> Responses = new List<String>();
            CurrentQuestioninfo Info = new CurrentQuestioninfo();
            using (SqlConnection Connection = new SqlConnection(con))
            {
                Connection.Open();
                SqlCommand SPGetQuestions = new SqlCommand("spGetQuestionandOptions", Connection);
                SPGetQuestions.CommandType = CommandType.StoredProcedure;
                int ID;
                if (OnloadPage == 0)
                {
                    ID = Convert.ToInt32(Session["CurrentID"]);
                    Responses = Session["Responses"] as List<String>;
                    string x = ID.ToString();
                    string R = Responses.Find(s => s.Contains(x + ","));
                    if (R is null)
                    {
                        Responses.Add(x + "," + SelectedOption);
                    }
                    else
                    {
                        int index = Responses.FindIndex(s => s == R);
                        Responses.RemoveAt(index);
                        Responses.Add(x + "," + SelectedOption);
                    }
                    ID = PreviousNextID == 1 ? ID + 1 : ID - 1;
                    R = Responses.Find(s => s.Contains(ID.ToString() + ","));
                    if (R is null)
                    {
                        Info.QuestionisAnswered = false;
                        Info.SelectedAnswer = "";
                    }
                    else
                    {
                        Info.QuestionisAnswered = true;
                        Info.SelectedAnswer = R.Substring(R.IndexOf(",") + 1);
                    }
                }
                else
                {
                    ID = 1;
                    List<String> NewResponses = new List<String>();
                    NewResponses.Add("");
                    Session["Responses"] = NewResponses;
                }
                SqlParameter PassID = new SqlParameter("@ID", ID);
                SPGetQuestions.Parameters.Add(PassID);
                SqlDataReader reader = SPGetQuestions.ExecuteReader();
                int n = 1;
                Info.CurrentQID = ID;
                while (reader.Read())
                {
                    if (n == 1)
                    {
                        Info.CurrentQStatement = reader["Question_Statement"].ToString();
                        Info.Options.Add(reader["Option_Text"].ToString());
                        Info.TotalQuestionCount = Convert.ToInt32(reader["TotalQ"]);
                        Session["TotalQCount"] = Convert.ToInt32(reader["TotalQ"]);
                        n++;
                    }
                    else
                    {
                        Info.Options.Add(reader["Option_Text"].ToString());
                        n++;
                    }
                }
                Info.TotalQuestionCount = Convert.ToInt32(Session["TotalQCount"]);
                reader.Close();
                Connection.Close();
                Session["CurrentID"] = ID;
                return Info;
            }
        }
        [WebMethod(EnableSession = true)]
        public void Submit(string SelectedOption)
        {
            string con = System.Configuration.ConfigurationManager.ConnectionStrings["YIP"].ConnectionString;
            using (SqlConnection Connection = new SqlConnection(con))
            {
                List<string> StoringResponses = new List<string>();
                StoringResponses = Session["Responses"] as List<String>;
                int ID;
                ID = Convert.ToInt32(Session["CurrentID"]);
                int QuestionCount = Convert.ToInt32(Session["TotalQCount"]);
                
                string x = ID.ToString();
                string R = StoringResponses.Find(s => s.Contains(x + ","));
                if (R is null)
                {
                    StoringResponses.Add(x + "," + SelectedOption);
                }
                if (StoringResponses.Count <= QuestionCount)
                {
                    for (int i = StoringResponses.Count; i <= QuestionCount; i++)
                    {
                        StoringResponses.Add(i.ToString() + "," + "");
                    }
                }
                Connection.Open();
                SqlCommand CommandStoringAttempt = new SqlCommand("spStoreAttempt", Connection);
                CommandStoringAttempt.CommandType = CommandType.StoredProcedure;
                CommandStoringAttempt.Parameters.AddWithValue("@CandidateID", Convert.ToInt32(Session["UserID"]));
                _ = CommandStoringAttempt.ExecuteNonQuery();
                int n = 0;
                foreach (string i in StoringResponses)
                {
                    SqlCommand CommandStoringAnswers = new SqlCommand("spStoreResponses", Connection);
                    CommandStoringAnswers.CommandType = CommandType.StoredProcedure;
                    CommandStoringAnswers.CommandText = "spStoreResponses";
                    if (n > 0)
                    {
                        CommandStoringAnswers.Parameters.AddWithValue("@QuestionID", Convert.ToInt32(i.Substring(0, i.IndexOf(","))));
                        CommandStoringAnswers.Parameters.AddWithValue("@Option", i.Substring(i.IndexOf(",") + 1));
                        CommandStoringAnswers.Parameters.AddWithValue("@Candidate_ID", Convert.ToInt32(Session["UserID"]));
                        _ = CommandStoringAnswers.ExecuteScalar();
                    }
                    n++;
                }
                Connection.Close();
            }
        }
        [WebMethod(EnableSession = true)]
        public void PrepareTest()
        {
            string con = System.Configuration.ConfigurationManager.ConnectionStrings["YIP"].ConnectionString;
            using (SqlConnection Connection = new SqlConnection(con))
            {
                Connection.Open();

                SqlCommand CommandCreatingTest = new SqlCommand("CreateTest", Connection);
                CommandCreatingTest.CommandType = CommandType.StoredProcedure;
                CommandCreatingTest.Parameters.AddWithValue("@ID", 1);
                CommandCreatingTest.ExecuteNonQuery();
                Connection.Close();
            }
        }
        [WebMethod(EnableSession = true)]
        public UserInfo UserSignin(string Email, string Password)
        {
            string con = ConfigurationManager.ConnectionStrings["YIP"].ConnectionString;
            string EncodedPassword = EncodePasswordToBase64(Password);
            using (SqlConnection Connection = new SqlConnection(con))
            {

                Connection.Open();

                SqlCommand CommandLogin = new SqlCommand("spUserSignin", Connection);
                CommandLogin.CommandType = CommandType.StoredProcedure;
                CommandLogin.Parameters.AddWithValue("@Email", Email);
                CommandLogin.Parameters.AddWithValue("@Password", EncodedPassword);
                SqlDataReader dataReader = CommandLogin.ExecuteReader();
                UserInfo UserInform = new UserInfo(0, "", Email, false);
                while (dataReader.Read())
                {
                    if (Convert.ToBoolean(dataReader["LoginStatus"]) == true)
                    {
                        Session["UserID"] = Convert.ToInt32(dataReader["ID"]);
                        Session["UserName"] = dataReader["UserName"].ToString();
                        Session["UserEmail"] = Email;
                        UserInfo UserInformation = new UserInfo(Convert.ToInt32(dataReader["ID"]), dataReader["UserName"].ToString(), Email, true);
                        dataReader.Close();
                        return UserInformation;
                    }
                    else
                    {
                        UserInfo UserInformation = new UserInfo(0, "", Email, false);
                        dataReader.Close();
                        return UserInformation;
                    }
                }
                dataReader.Close();
                Connection.Close();
                return UserInform;
            }
        }
        [WebMethod(EnableSession = true)]
        public UserInfo UserSignup(string Name, string DOB, string Email, string Password)
        {
            string con = System.Configuration.ConfigurationManager.ConnectionStrings["YIP"].ConnectionString;
            string EncodedPassword = EncodePasswordToBase64(Password);
            using (SqlConnection Connection = new SqlConnection(con))
            {
                Connection.Open();

                DateTime datetime = DateTime.ParseExact(DOB, "dd/MM/yyyy", null);
                SqlCommand CommandSignup = new SqlCommand("spUserSignup", Connection);
                CommandSignup.CommandType = CommandType.StoredProcedure;
                CommandSignup.Parameters.AddWithValue("@Name", Name);
                CommandSignup.Parameters.AddWithValue("@DOB", datetime);
                //datetime = Convert.ToDateTime(datetime, System.Globalization.CultureInfo.GetCultureInfo("hi-IN").DateTimeFormat);
                CommandSignup.Parameters.AddWithValue("@Email", Email);
                CommandSignup.Parameters.AddWithValue("@Password", EncodedPassword);
                string SignupSuccess = CommandSignup.ExecuteScalar().ToString();
                Connection.Close();
                //UserInfo UserInform = new UserInfo();
                if (SignupSuccess == "Successful") {
                    UserInfo UserInform = UserSignin(Email, Password);
                    return UserInform;
                }
                else
                {
                    UserInfo UserInform = new UserInfo(Email, Password, SignupSuccess);
                    return UserInform;
                }
            }
        }

        [WebMethod(EnableSession = true)]
        public int SendingCode(string Email)
        {
            string con = System.Configuration.ConfigurationManager.ConnectionStrings["YIP"].ConnectionString;
            using (SqlConnection Connection = new SqlConnection(con))
            {
                Connection.Open();

                SqlCommand CommandSendCode = new SqlCommand("SendCode", Connection);
                CommandSendCode.CommandType = CommandType.StoredProcedure;
                CommandSendCode.Parameters.AddWithValue("@Email", Email);
                int Code = Convert.ToInt32(CommandSendCode.ExecuteScalar());
                Connection.Close();
                return Code;
            }
        }

        public static string EncodePasswordToBase64(string password)
        {
            byte[] bytes = System.Text.Encoding.Unicode.GetBytes(password);
            byte[] inArray = HashAlgorithm.Create("SHA1").ComputeHash(bytes);
            return Convert.ToBase64String(inArray);
        }
    }

    public class CurrentQuestioninfo
    {
        public int CurrentQID;
        public string CurrentQStatement;
        public int TotalQuestionCount;
        public List<string> Options = new List<string>();
        public string Option1;
        public string Option2;
        public string Option3;
        public bool QuestionisAnswered;
        public string SelectedAnswer;
    }
}
