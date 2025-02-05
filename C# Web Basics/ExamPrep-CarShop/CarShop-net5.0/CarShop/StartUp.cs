﻿namespace CarShop
{
    using MyWebServer;
    using CarShop.Data;
    using System.Threading.Tasks;
    using MyWebServer.Controllers;
    using MyWebServer.Results.Views;
    using Microsoft.EntityFrameworkCore;
    using CarShop.Services;
    

    public class Startup
    {
        public static async Task Main()
            => await HttpServer
                .WithRoutes(routes => routes
                    .MapStaticFiles()
                    .MapControllers())
                .WithServices(services => services
                .Add<ApplicationDbContext>()
                .Add<IViewEngine, CompilationViewEngine>()
                .Add<IValidator, Validator>()
                .Add<IUserService, UserService>()
                .Add<IPasswordHasher, PasswordHasher>())
                .WithConfiguration<ApplicationDbContext>(context => context
                    .Database.Migrate())
                .Start();
    }
}
