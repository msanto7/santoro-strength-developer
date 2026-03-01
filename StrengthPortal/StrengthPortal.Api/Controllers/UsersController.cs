using Microsoft.AspNetCore.Mvc;

namespace StrengthPortal.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class UsersController : ControllerBase
{
    [HttpGet]
    public IActionResult GetAll()
    {
        return Ok(new[] { "user1", "user2" });
    }

    [HttpGet("{id:int}")]
    public IActionResult GetById(int id)
    {
        return Ok(new { Id = id, Name = $"user{id}" });
    }

    [HttpPost]
    public IActionResult Create([FromBody] CreateUserRequest request)
    {
        if (string.IsNullOrWhiteSpace(request.Name))
            return BadRequest("Name is required.");

        var createdUser = new { Id = 1, request.Name };
        return CreatedAtAction(nameof(GetById), new { id = createdUser.Id }, createdUser);
    }

    [HttpPut("{id:int}")]
    public IActionResult Update(int id, [FromBody] UpdateUserRequest request)
    {
        if (string.IsNullOrWhiteSpace(request.Name))
            return BadRequest("Name is required.");

        return NoContent();
    }

    [HttpDelete("{id:int}")]
    public IActionResult Delete(int id)
    {
        return NoContent();
    }
}

public record CreateUserRequest(string Name);
public record UpdateUserRequest(string Name);