﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using static CarShop.Data.DataConstants;

namespace CarShop.Data.Models
{
    public class Car
    {
        [Key]
        [Required]
        [MaxLength(IdMaxLength)]
        public string Id { get; set; } = Guid.NewGuid().ToString();

        [Required]
        [MaxLength(ModelMaxLength)]
        public string Model { get; set; }

        [Required]
        public int Year { get; set; }

        [Required]
        public string PictureUrl { get; set; }

        [Required]
        [RegularExpression(PlateNumberRegex)]
        public string PlateNumber { get; set; }

        [Required]
        [ForeignKey(nameof(Owner))]
        public string OwnerId { get; set; }

        public User Owner { get; set; }

        public ICollection<Issue> Issues { get; set; } = new List<Issue>();
    }
}