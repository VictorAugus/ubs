trigger emailForgotTrigger on emailForgot__e (after insert) {
        SendEmailClass.SendEmail();
}