﻿using System;
using System.Collections.Generic;
using System.Linq;

namespace ComparingObjects
{
    public class Program
    {
        static void Main(string[] args)
        {
            SortedDictionary<int, Person> people = new SortedDictionary<int, Person>();

            int index = 1;

            while (true)
            {
                                string[] input = Console.ReadLine()
                    .Split(' ', StringSplitOptions.RemoveEmptyEntries)
                    .ToArray();


                if (input[0] == "END")
                {
                    break;
                }

                string name = input[0];
                int age = int.Parse(input[1]);
                string town = input[2];


                var person = new Person(name, age, town);

                people.Add(index, person);

                index++;
            }

            int indexOfPersonToCompare = int.Parse(Console.ReadLine());
            Person personToCompare = people[indexOfPersonToCompare];

            int totalCount = people.Count;
            int countOfMacthes = 0;
            int countOfNotEqual = 0;

            foreach (var currentPerson in people.Values)
            {
                if (personToCompare.CompareTo(currentPerson) == 0)
                {
                    countOfMacthes++;
                }
                else
                {
                    countOfNotEqual++;
                }
            }

            if (countOfMacthes == 1)
            {
                Console.WriteLine("No matches");
            }
            else
            {
                Console.WriteLine($"{countOfMacthes} {countOfNotEqual} {totalCount}");

            }

        }
    }
}