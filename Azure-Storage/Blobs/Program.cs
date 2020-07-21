using System;
using System.Threading.Tasks;
using Azure.Storage.Blobs;

namespace Blobs
{
    internal class Program
    {
        private static async Task Main(string[] args)
        {
            const string connectionString = "Connection string";
            var blobServiceClient = new BlobServiceClient(connectionString);
            var response = await blobServiceClient.CreateBlobContainerAsync("sample-container");
            var blobContainerClient = response.Value;

            Console.WriteLine(blobContainerClient.Name);
        }
    }
}
