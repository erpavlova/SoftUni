﻿
namespace SharedTrip.Services
{
    public interface IPasswordHasher
    {
        string HashPassword(string password);
    }
}
