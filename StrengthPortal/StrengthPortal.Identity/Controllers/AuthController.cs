using Microsoft.AspNetCore.Mvc;
using StrengthPortal.Identity.Application.Abstractions;

namespace StrengthPortal.Identity.Controllers;

[ApiController]
[Route("api/[controller]")]
public sealed class AuthController(ITokenService tokenService) : ControllerBase
{
    [HttpPost("login")]
    public IActionResult Login([FromBody] LoginRequest request)
    {
        // Temporary stub auth flow for initial end-to-end wiring.
        const string seededEmail = "mike.santoro42@gmail.com";
        const string seededPassword = "root";

        if (!string.Equals(request.Email, seededEmail, StringComparison.OrdinalIgnoreCase) ||
            !string.Equals(request.Password, seededPassword, StringComparison.Ordinal))
        {
            return Unauthorized(new { message = "Invalid email or password." });
        }

        var token = tokenService.CreateToken(
            userId: 1,
            email: seededEmail,
            fullName: "Admin User");

        return Ok(new LoginResponse(token));
    }
}

public sealed record LoginRequest(string Email, string Password);
public sealed record LoginResponse(string AccessToken);
