using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace WebApp.Home
{
    public class HomeController : Controller
    {
        public IActionResult Index()
        {
            return View("~/Home/Index.cshtml");
        }

        [Authorize]
        public IActionResult Profile()
        {
            return View("~/Home/Profile.cshtml");
        }
    }
}
