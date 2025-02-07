using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MusicSpot.Data;
using MusicSpot.Data.Identity;
using MusicSpot.Infrastructure.Extensions;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services
    .AddDbContext<MusicSpotDbContext>(options =>
    options.UseSqlServer(connectionString));
builder.Services
    .AddDatabaseDeveloperPageExceptionFilter();

builder.Services
    .AddDefaultIdentity<User>(options =>
    {
        options.SignIn.RequireConfirmedAccount = false;
        options.Password.RequireDigit = false;
        options.Password.RequireNonAlphanumeric = false;
        options.Password.RequireLowercase = false;
        options.Password.RequireUppercase = false;

    })
    .AddRoles<IdentityRole>()
    .AddEntityFrameworkStores<MusicSpotDbContext>();

builder.Services.AddAutoMapper(typeof(Program));

builder.Services.AddMemoryCache();

builder.Services
    .AddControllersWithViews(options =>
    {
        options.Filters.Add<AutoValidateAntiforgeryTokenAttribute>();
    });

var app = builder.Build();

app.PrepareDatabase();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseMigrationsEndPoint();
}
else
{
    app.UseExceptionHandler("/Home/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllerRoute(
    name: "Areas",
    pattern: "{area:exists}/{controller=Home}/{action=Index}/{id?}");

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

//app.MapControllerRoute(
//    name: "Tracks",
//    pattern: "{controller=Tracks}/{action=Create}/{id?}");

app.MapRazorPages();

app.Run();
