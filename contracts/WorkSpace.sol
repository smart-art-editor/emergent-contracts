// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract WorkSpace{
    struct Video_WorkSpace{
        string name;
        address workspace_creator;
        address[] participants;
        string[] videoIds;
    }
    struct Creator{
        address creatorAddress;
        uint256[] workspaceIds;
    }
    Video_WorkSpace[] public workspaces;
    mapping(address => Creator) public creators;
    mapping(address => uint256[]) public participantWorkspaces;
    uint256 public workspaceCount;

    event WorkspaceCreated(uint256 workspaceId, string name, address creator);
    event VideoAdded(uint256 workspaceId, string videoId);
    event ParticipantAdded(uint256 workspaceId, address participant);

    function createWorkspace(string memory _name,address  _initialParticipant, string memory _videoId) public {
        uint256 newWorkspaceId = workspaceCount;
    
    // Create a new Video_WorkSpace struct and push it to the array
    workspaces.push(Video_WorkSpace({
        name: _name,
        workspace_creator: msg.sender,
        participants: new address[](0),
        videoIds: new string[](0)
    }));

    // Add the initial participant (creator)
    workspaces[newWorkspaceId].participants.push(_initialParticipant);
    participantWorkspaces[_initialParticipant].push(newWorkspaceId);
    workspaces[newWorkspaceId].videoIds.push(_videoId);

    // Update creator information
    creators[msg.sender].creatorAddress = msg.sender;
    creators[msg.sender].workspaceIds.push(newWorkspaceId);

    workspaceCount++;

    emit WorkspaceCreated(newWorkspaceId, _name, msg.sender);
    emit ParticipantAdded(newWorkspaceId, _initialParticipant);
    }

    function addVideoToWorkspace(uint256 _workspaceId, string memory _videoId) public {
        require(_workspaceId < workspaces.length, "Workspace does not exist");
        require(msg.sender == workspaces[_workspaceId].workspace_creator, "Only creator can add videos");

        workspaces[_workspaceId].videoIds.push(_videoId);
        emit VideoAdded(_workspaceId, _videoId);
    }
    function addParticipantToWorkspace(uint256 _workspaceId, address _participant) public {
        require(_workspaceId < workspaces.length, "Workspace does not exist");
        require(msg.sender == workspaces[_workspaceId].workspace_creator, "Only creator can add participants");

        workspaces[_workspaceId].participants.push(_participant);
        participantWorkspaces[_participant].push(_workspaceId);
        emit ParticipantAdded(_workspaceId, _participant);
    }

    function getCreatorWorkspaces(address _creator) public view returns (uint256[] memory) {
        return creators[_creator].workspaceIds;
    }

    function getWorkspaceDetails(uint256 _workspaceId) public view returns (
        string memory name,
        address workspace_creator,
        address[] memory participants,
        string[] memory videoIds
    ) {
        require(_workspaceId < workspaces.length, "Workspace does not exist");
        Video_WorkSpace storage workspace = workspaces[_workspaceId];
        return (
            workspace.name,
            workspace.workspace_creator,
            workspace.participants,
            workspace.videoIds
        );
    }
    function getAllWorkspaces() public view returns (uint256[] memory) {
        uint256[] memory allWorkspaceIds = new uint256[](workspaceCount);
        for (uint256 i = 0; i < workspaceCount; i++) {
            allWorkspaceIds[i] = i;
        }
        return allWorkspaceIds;
    }

    function getParticipantWorkspaces(address _participant) public view returns (uint256[] memory) {
        return participantWorkspaces[_participant];
    }

}