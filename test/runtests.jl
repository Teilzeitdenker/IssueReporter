using IssueReporter
using Test, URIParser, GitHub
@testset "Basic features" begin
    @testset "Looking up an existing package returns a proper repo URI" begin
        @test IssueReporter.packageuri("DataFrames") |> URIParser.isvalid
    end
end
@testset "Interacting with the registry" begin
    @testset "The General Registry is accessible" begin
        @test IssueReporter.generalregistrypath() |> Base.Filesystem.isdir
    end
end

@testset "GitHub integration" begin
    @testset "Token is defined" begin
        @test IssueReporter.tokenisdefined()
    end
    @testset "A valid token is a non empty string and has the set value" begin
        token = IssueReporter.token()
        @test isa(token, String) && !isempty(token)
    end
end

@testset "Adding GitHub issues" begin
    delete!(ENV, "GITHUB_ACCESS_TOKEN")
    @testset "Successful authentication should return a valid AuthO2 instance" begin
        @test isa(IssueReporter.githubauth(), GitHub.OAuth2)
    end
    @testset "Converting package name to github id" begin
        @test IssueReporter.repoid("IssueReporter") == "essenciary/IssueReporter.jl"
    end
    @testset "Submitting a github issue should result in an GitHub.Issue object" begin
        isa(IssueReporter.report("IssueReporter", "I found a bug", "Here is how you can reproduce the problem: ... "), GitHub.Issue)
    end
end