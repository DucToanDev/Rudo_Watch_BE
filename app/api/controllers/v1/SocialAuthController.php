<?php
require_once __DIR__ . '/../../../models/LoginWithFacebook.php';
require_once __DIR__ . '/../../../core/Response.php';

class SocialAuthController
{
    private $fbModel;

    public function __construct()
    {
        $this->fbModel = new LoginWithFacebook();
    }

    // Start the flow: return a login_url for frontend to redirect (or may redirect itself)
    public function facebookStart($data)
    {
        // The model method will handle returning JSON responses directly
        $this->fbModel->facebookLogin();
    }

    // Callback from Facebook (FB redirects here) - model will process token and return user/token
    public function facebookCallback($data)
    {
        $this->fbModel->facebookLogin();
    }
}
