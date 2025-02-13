﻿using Bakery.Models.BakedFoods.Contracts;
using System;
using System.Collections.Generic;
using System.Text;

namespace Bakery.Models.BakedFoods
{
    public abstract class BakedFood : IBakedFood
    {
        private string name;
        private int portion;
        private decimal price;

        protected BakedFood(string name, int portion, decimal price)
        {
            Name = name;
            Portion = portion;
            Price = price;
        }

        public string Name 
        {
            get => name;
            private set
            {
                if (String.IsNullOrWhiteSpace(value))
                {
                    throw new ArgumentException("Name cannot be null or white space!");
                }

                name = value;
            }
        }

        public int Portion 
        {
            get => portion;
            private set
            {
                if (value <= 0)
                {
                    throw new ArgumentException("Portion cannot be less or equal to zero");
                }

                portion = value;
            } 
        }

        public decimal Price 
        {
            get => price;
            private set
            {
                if (value <= 0)
                {
                    throw new ArgumentException("Price cannot be less or equal to zero!");
                }

                price = value;
            }
        }

        public override string ToString()
        {
            return $"{Name}: {Portion}g - {Price:F2}"; // get.type().Name ???????
        }
    }
}
