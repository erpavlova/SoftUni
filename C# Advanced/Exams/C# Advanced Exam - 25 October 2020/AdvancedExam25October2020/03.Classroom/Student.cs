﻿using System;
using System.Collections.Generic;
using System.Text;

namespace ClassroomProject
{
    public class Student
    {
        private string firstName;
        private string lastName;
        private string subject;

        public Student(string firstName, string lastName, string subject)
        {
            this.FirstName = firstName;
            this.LastName = lastName;
            this.Subject = subject;
        }

        public string FirstName
        {
            get { return firstName; }
            set { firstName = value; }
        }
        public string LastName
        {
            get { return lastName; }
            set { lastName = value; }
        }
        public string Subject
        {
            get { return subject; }
            set { subject = value; }
        }


        public override string ToString()
        {
            return $"Student: First Name = {firstName}, Last Name = {lastName}, Subject = {subject}";
        }
    }
}
