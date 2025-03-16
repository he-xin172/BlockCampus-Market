
document.getElementById('uploadForm').addEventListener('submit', async (event) => {
    event.preventDefault();
    const fileInput = document.getElementById('fileInput');
    const file = fileInput.files[0];

    if (!file) {
        alert('Please select a file.');
        return;
    }

    // Create a FormData object and append the file
    const formData = new FormData();
    formData.append('file', file);

    // Pinata API credentials (replace with your actual API key and secret)

    const pinataApiKey = 'f6b13c955cea37745807';
    const pinataSecretApiKey = '43ff43a4d8c2850ba4eb1c8ea590c083b17ef119b21128ff3e4f54d0a00a20fe';

    try {
        const response = await fetch('https://api.pinata.cloud/pinning/pinFileToIPFS', {
            method: 'POST',
            headers: {
                'pinata_api_key': pinataApiKey,
                'pinata_secret_api_key': pinataSecretApiKey
            },
            body: formData
        });

        if (!response.ok) {
            throw new Error(`Error: ${response.statusText}`);
        }

        const data = await response.json();
        const cid = data.IpfsHash;

        // Display the result
        const resultDiv = document.getElementById('result');
        resultDiv.innerHTML = `
            <p>图片上传成功!</p>
            <p>CID: ${cid}</p>
            <p><a href="https://gateway.pinata.cloud/ipfs/${cid}" target="_blank">View File</a></p>
            <p><a href="https://gateway.pinata.cloud/ipfs/${cid}" download>Download File</a></p>
        `;
    } catch (error) {
        console.error('Error uploading file:', error);
        alert('Error uploading file. Please try again.');
    }
});
