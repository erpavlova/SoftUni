﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace TeisterMask.Data.Models
{
    public class Project
    {
        public Project()
        {
            this.Tasks = new List<Task>();
        }

        [Key]
        public int Id { get; set; }

        [Required]
        [MaxLength(40)]
        public string Name { get; set; }

        [Required]
        public DateTime OpenDate { get; set; }

        [Required]   // its easyer to catch error
        public DateTime? DueDate { get; set; }

        public ICollection<Task> Tasks { get; set; }
    }
}
