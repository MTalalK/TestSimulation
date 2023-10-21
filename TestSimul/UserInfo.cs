using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TestSimul
{
    public class UserInfo
    {
        public int UserID = 0;
        public string UserName = "";
        public string UserDOB = "";
        public string UserEmail = "";
        public string UserPassword = "";
        public bool isPasswordCorrect = false;
        public string SignupMessage = "";
        public UserInfo()
        {

        }
        public UserInfo(string Email, string Password, string Signupmessage)
        {
            UserEmail = Email;
            UserPassword = Password;
            SignupMessage = Signupmessage;
        }
        public UserInfo(int UID, string Name, string Email, bool PasswordCorrect)
        {
            UserID = UID;
            UserName = Name;
            UserEmail = Email;
            isPasswordCorrect = PasswordCorrect;
        }
        public UserInfo(string Name, string DOB, string Email, string Password)
        {
            UserName = Name;
            UserDOB = DOB;
            UserEmail = Email; 
            UserPassword = Password;
        }
    }
}